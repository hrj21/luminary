lapply(names(fits), function(x) {

  lloq <- dplyr::filter(
    u5plex@summary_data,
    Analyte == x,
    Type == "Standard",
    Result_CV <= 0.2,
    Result_Avg / Expected > 0.8,
    Result_Avg / Expected < 1.2
  ) |>
    dplyr::pull(Expected) |>
    min()

  blank <- dplyr::filter(
    u5plex@well_data,
    Analyte == x,
    Type == "Standard",
    Expected == 0
  ) |>
    dplyr::pull(MFI)

  blank_targets <-
    (mean(blank) + 2.5*sd(blank)) /
    max(dplyr::filter(u5plex@well_data, Analyte == x)$MFI)

  suppressWarnings({
    suppressMessages({
      mdd <- nplr::getEstimates(
        fits[[x]],
        targets = blank_targets
      )$x
    })
  })

  df_low <- data.frame(
    x = 10^(fits[[x]]@x),
    y = fits[[x]]@y
  )[10^(fits[[x]]@x) %in% unique(10^(fits[[x]]@x))[1:3],]

  fit_low <- nplr::nplr(
    x        = df_low$x,
    y        = df_low$y#,
    # npars    = npars,
    # method   = weight_method,
    # LPweight = LPweight,
    # silent   = silent
  )

  suppressWarnings({
    suppressMessages({
      lod <- nplr::getEstimates(
        fit_low,
        targets = blank_targets
      )$x
    })
  })

  tibble::tibble(
    Analyte     = x,
    Fit         = paste0("nplr ", fits[[x]]@npars, "PL"),
    LLoQ        = lloq,
    MDD         = mdd,
    LoD         = lod,
    `R Squared` = fits[[x]]@goodness$gof,
    Slope       = fits[[x]]@pars$s
  )
}) |> dplyr::bind_rows()

