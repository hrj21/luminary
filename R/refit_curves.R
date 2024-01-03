#' Refit standard curves
#'
#' Function to refit n-parameter logistic curves to standards in an intelliframe object
#'   and interpolate concentrations for all samples, based on the updated models.
#'
#' @details
#' The 5-parameter logistic regression is of the form:
#'   y = B + (T - B)/[1 + 10^(b*(xmid - x))]^s
#'
#'   where B and T are the bottom and top asymptotes, respectively, b and xmid are the Hill slope and the x-coordinate at the inflexion point, respectively, and s is an asymetric coefficient. This equation is sometimes refered to as the Richards' equation [1,2].
#'   When specifying npars = 4, the s parameter is forced to be 1, and the corresponding model is a 4-parameter logistic regression, symetrical around its inflexion point. When specifying npars = 3 or npars = 2, add 2 more constraints and force B and T to be 0 and 1, respectively.
#'   Weight methods:
#'   The model parameters are optimized, simultaneously, using nlm, given a sum of squared errors function, sse(Y), to minimize:
#'   sse(Y) = Σ [W.(Yobs - Yfit)^2 ]
#'   where Yobs, Yfit and W are the vectors of observed values, fitted values and weights, respectively.
#'   In order to reduce the effect of possible outliers, the weights can be computed in different ways, specified in nplr:
#'   residual weights, "res":
#'   W = (1/residuals)^LPweight
#'   where residuals and LPweight are the squared error between the observed and fitted values, and a tuning parameter, respectively. Best results are generally obtained by setting LPweight = 0.25 (default value), while setting LPweight = 0 results in computing a non-weighted sum of squared errors.
#'   standard weights, "sdw":
#'   W = 1/Var(Yobs_r)
#'   where Var(Yobs_r) is the vector of the within-replicates variances.
#'   general weights, "gw":
#'   W = 1/Yfit^LPweight
#'   where Yfit are the fitted values. As for the residuals-weights method, setting LPweight = 0 results in computing a non-weighted sum of squared errors.
#'   The standard weights and general weights methods are describes in [3].
#' @param .data Intelliframe object to refit
#' @param npars A numeric value (or \code{"all"}) to specify the number of
#'   parameters to use in the model. If \code{"all"} the logistic model will be
#'   tested with 2 to 5 parameters, and the best option will be returned.
#'   See Details.
#' @param weight_method A character string to specify what weight method to use.
#'   Options are \code{"res"}(default), \code{"sdw"}, \code{"gw"}. See Details.
#' @param add_to_zeroes A numeric value (\code{0.1} by default) added to zeros during
#'   the curve fitting procedure as it requires the concentration to be
#'   log10-transformed.
#' @param silent Logical flag indicating whether warnings and/or messages during
#'   curve fitting should be silenced. Defaults to \code{FALSE}.
#'
#' @return An intelliframe
#' @export
#'
#' @examples
#' 1+1
refit_curves <- function(.data, npars = "all", weight_method = "res", add_to_zeroes = 0.02, silent = FALSE) {

  well_data <- get_well_data(.data)

  standards <-  dplyr::filter(well_data, Type == "Standard")

  expected <- get_expected(.data) |>
    dplyr::select(Plate, Group, `Well ID`, `Sample ID`, Standard, Type, Analyte, Expected)

  standard_list <- dplyr::left_join(
    standards,
    expected,
    by = c("Plate", "Group", "Well ID", "Sample ID", "Standard", "Type", "Analyte", "Expected")
  )

  standard_list <- split(standard_list, standard_list$Analyte)

  fits <- lapply(standard_list, function(analyte) {
    non_zero <- ifelse(
      analyte$Expected < 1,
      analyte$Expected + add_to_zeroes,
      analyte$Expected
    )

    fit <- nplr::nplr(
      x      = non_zero,
      y      = analyte$MFI/max(analyte$MFI),
      npars  = npars,
      method = weight_method,
      silent = silent
    )
  })

  names(fits) <- names(standard_list)

  suppressWarnings({
    refitted <- lapply(names(fits), function(analyte) {
      maximum <- max(standard_list[[analyte]]$MFI)
      dplyr::filter(well_data, Analyte == analyte) |>
        dplyr::mutate(Result = nplr::getEstimates(fits[[analyte]], targets = MFI / maximum)$x)
    }) |> dplyr::bind_rows()
  })

  intelliframe_out <- .data
  intelliframe_out@well_data <- refitted

  intelliframe_out@recovery <- dplyr::filter(refitted, Type %in% c("Standard", "Control")) |>
    dplyr::mutate(Recovery = dplyr::case_when(
      Expected == 0 ~ NA_real_,
      .default = Result / Expected
    )) |>
    dplyr::select(-c("MFI", "Result", "Messages", "Exclude Reason", "Excluded", "Expected"))

  intelliframe_out@recovery_avg <- intelliframe_out@recovery |>
    dplyr::select(-Location) |>
    dplyr::left_join(
      dplyr::select(intelliframe_out@recovery_avg, -Recovery),
      by = c("Plate", "Group", "Well ID", "Sample ID", "Standard", "Type", "Analyte")
      ) |>
    dplyr::select(
      "Plate", "Group", "Location", "Well ID", "Sample ID", "Standard", "Type",
      "Analyte", "Recovery"
    ) |>
    dplyr::summarise(
      .by = c("Plate", "Group", "Location", "Well ID", "Sample ID", "Standard",
              "Type", "Analyte"),
      Recovery = mean(Recovery, na.rm = TRUE)
    )

  intelliframe_out
}
