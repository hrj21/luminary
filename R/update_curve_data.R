#' update_curve_data
#'
#' Update the curve_data property from an intelliframe object using a list of
#'   model fits. Not meant to be called by the user.
#'
#' @param .summary_data A tibble containing the summary_data property.
#' @param .well_data A tibble containing the well_data property.
#' @param .fits A list of model fits returned by \code{nplr::nplr()}.
#' @param .silent Should luminary warnings be printed?
#'
#' @return A tibble
#'
update_curve_data <- function(.summary_data, .well_data, .fits, .silent) {

new_curve_data <- lapply(names(.fits), function(x) {

  lloq <- dplyr::filter(
    .summary_data,
    Analyte == x,
    Type == "Standard",
    Result_CV <= 0.2,
    dplyr::n() > 1,
    Result_Avg / Expected > 0.8,
    Result_Avg / Expected < 1.2
  ) |>
    dplyr::pull(Expected) |>
    min()

  blank <- dplyr::filter(
    .summary_data,
    Analyte == x,
    Type == "Standard",
    Expected == 0
  )

  analyte  <- dplyr::filter(.well_data, Analyte == x)
  analyte  <- analyte[!analyte$Excluded, ]
  standard <- dplyr::filter(analyte, Type == "Standard")

  blank_targets <- (blank$MFI_Avg + 2.5 * blank$MFI_SD) / max(standard$MFI)

  suppressWarnings({
    suppressMessages({
      mdd <- nplr::getEstimates(
        .fits[[x]],
        targets = blank_targets
      )$x
    })
  })

  df_low <- data.frame(
    x = 10^(.fits[[x]]@x),
    y = .fits[[x]]@y
  )[10^(.fits[[x]]@x) %in% unique(10^(.fits[[x]]@x))[2:4],]

  fit_low <- nplr::nplr(
    x        = df_low$x,
    y        = df_low$y,
    silent   = TRUE
  )

  suppressWarnings({
    suppressMessages({
      lod <- nplr::getEstimates(fit_low, targets = blank_targets)$x
    })
  })

  if(.fits[[x]]@weightMethod == "res") {
    weight_meth <- paste0("(1/residual)^", .fits[[x]]@LPweight)
  } else if(.fits[[x]]@weightMethod == "sdw") {
    weight_meth <- "1/Var(y)"
  } else if(.fits[[x]]@weightMethod == "gw") {
    weight_meth <- paste0("1/fitted^", .fits[[x]]@LPweight)
  }

  model_eqn <- paste0(
    "y = ",
    .fits[[x]]@pars["bottom"],
    " + (",
    .fits[[x]]@pars["top"],
    " - ",
    .fits[[x]]@pars["bottom"],
    ") / (1 + 10^(",
    .fits[[x]]@pars["bottom"],
    " * (",
    .fits[[x]]@pars["xmid"],
    " - x)))^",
    .fits[[x]]@pars["s"]
  )

  tibble::tibble(
    Group       = analyte$Group,
    Analyte     = x,
    Fit         = paste0("nplr ", .fits[[x]]@npars, "PL"),
    LLoQ        = lloq,
    MDD         = mdd,
    LoD         = lod,
    `R Squared` = .fits[[x]]@goodness$gof,
    Slope       = .fits[[x]]@pars$s,
    Weighting   = weight_meth,
    Equation    = model_eqn
  )
}) |> dplyr::bind_rows()

if(!.silent) {
  warning(
    "LLoQ, MDD, and LoD may be calculated differently than in Belysa. See ?refit_curves for details.",
    call. = FALSE
  )
}

new_curve_data
}
