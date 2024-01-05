#' Refit standard curves
#'
#' Function to refit n-parameter logistic curves to standards in an intelliframe object
#'   and interpolate concentrations for all samples, based on the updated models.
#'
#' @details
#' Most of these details have been reproduced from the \code{\link{nplr}} function that is doing most of the heavy lifting.
#'
#' The 5-parameter logistic regression is of the form:
#' \deqn{y = B + (T - B)/[1 + 10^{(b*(x_{\text{mid}} - x))}]^s}
#'
#'   where \eqn{B} and \eqn{T} are the bottom and top asymptotes, respectively,
#'   \eqn{b} and \eqn{x_{\text{mid}}} are the Hill slope and the x-coordinate at
#'   the inflection point, respectively, and \eqn{s} is an asymmetric coefficient.
#'   This equation is sometimes referred to as the Richards' equation \[1,2\].
#'   When specifying \code{npars = 4}, the \eqn{s} parameter is forced to be 1,
#'   and the corresponding model is a 4-parameter logistic regression, symmetrical
#'   around its inflection point. When specifying \code{npars = 3} or \code{npars = 2},
#'   add 2 more constraints and force \eqn{B} and \eqn{T} to be 0 and 1, respectively.
#'
#'   Weight methods:
#'
#'   The model parameters are optimized, simultaneously, using \code{\link{nlm}},
#'   given a sum of squared errors function, \eqn{\text{sse(Y)}}, to minimize:
#'   \deqn{\text{sse}(Y) = Σ [W(Y_{\text{obs}} - Y_{\text{fit}})^2 ]}
#'   where \eqn{Y_{\text{obs}}}, \eqn{Y_{\text{fit}}} and \eqn{W} are the vectors
#'   of observed values, fitted values and weights, respectively.
#'   In order to reduce the effect of possible outliers, the weights can be computed in different ways:
#'
#'   residual weights, \code{"res"}:
#'   \deqn{W = (1/\text{residuals})^\text{LPweight}}
#'   where \eqn{\text{residuals}} and \eqn{\text{LPweight}} are the squared error
#'   between the observed and fitted values, and a tuning parameter, respectively.
#'   Best results are generally obtained by setting \code{LPweight = 0.25} (default value),
#'   while setting \code{LPweight = 0} results in computing a non-weighted sum of squared errors.
#'
#'   standard weights, \code{"sdw"}:
#'   \deqn{W = 1/\text{Var}(Y_{\text{obs}_r})}
#'   where \eqn{\text{Var}(Y_{\text{obs}_r})} is the vector of the within-replicates variances.
#'
#'   general weights, \code{"gw"}:
#'   \deqn{W = 1/Y_{\text{fit}}^\text{LPweight}}
#'   where \eqn{Y_{\text{fit}}} are the fitted values. As for the residuals-weights method,
#'   setting \eqn{LPweight = 0} results in computing a non-weighted sum of squared errors.
#'   The standard weights and general weights methods are described in \[3\].
#' @param .intelliframe Intelliframe object to refit
#' @param npars A numeric value (or \code{"all"}) to specify the number of
#'   parameters to use in the model. If \code{"all"} the logistic model will be
#'   tested with 2 to 5 parameters, and the best option will be returned.
#'   See Details.
#' @param weight_method A character string to specify what weight method to use.
#'   Options are \code{"res"}(default), \code{"sdw"}, \code{"gw"}. See Details.
#' @param LPweight a coefficient to adjust the weights. \code{LPweight = 0} will
#'   compute a non-weighted np-logistic regression.
#' @param add_to_zeroes A numeric value (\code{0.1} by default) added to zeros during
#'   the curve fitting procedure as it requires the concentration to be
#'   log10-transformed.
#' @param silent Logical flag indicating whether warnings and/or messages during
#'   curve fitting should be silenced. Defaults to \code{FALSE}.
#'
#' @references
#' 1- Richards, F. J. (1959). A flexible growth function for empirical use. J Exp Bot 10, 290-300.
#'
#' 2- Giraldo J, Vivas NM, Vila E, Badia A. Assessing the (a)symmetry of
#' concentration-effect curves: empirical versus mechanistic models. Pharmacol Ther. 2002 Jul;95(1):21-45.
#'
#' 3- Motulsky HJ, Brown RE. Detecting outliers when fitting data with nonlinear
#' regression - a new method based on robust nonlinear regression and the false
#' discovery rate. BMC Bioinformatics. 2006 Mar 9;7:123.
#'
#' @return An intelliframe
#' @export
#'
#' @examples
#' 1+1
refit_curves <- function(.intelliframe, npars = "all", weight_method = "res", LPweight = 0.25, add_to_zeroes = 0.02, silent = FALSE) {

  well_data <- get_well_data(.intelliframe)

  standards <-  dplyr::filter(well_data, .data[["Type"]] == "Standard")

  expected <- get_expected(.intelliframe) |>
    dplyr::select("Plate", "Group", "Well ID", "Sample ID", "Standard", "Type", "Analyte", "Expected")

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
      x        = non_zero,
      y        = analyte$MFI/max(analyte$MFI),
      npars    = npars,
      method   = weight_method,
      LPweight = LPweight,
      silent   = silent
    )
  })

  names(fits) <- names(standard_list)

  suppressWarnings({
    refitted <- lapply(names(fits), function(analyte) {
      maximum <- max(standard_list[[analyte]]$MFI)
      dplyr::filter(well_data, .data[["Analyte"]] == analyte) |>
        dplyr::mutate(Result = nplr::getEstimates(fits[[analyte]], targets = .data[["MFI"]] / maximum)$x)
    }) |> dplyr::bind_rows()
  })

  intelliframe_out <- .intelliframe
  intelliframe_out@well_data <- refitted

  intelliframe_out@recovery <- dplyr::filter(refitted, .data[["Type"]] %in% c("Standard", "Control")) |>
    dplyr::mutate(Recovery = dplyr::case_when(
      .data[["Expected"]] == 0 ~ NA_real_,
      .default = .data[["Result"]] / .data[["Expected"]]
    )) |>
    dplyr::select(-c("MFI", "Result", "Messages", "Exclude Reason", "Excluded", "Expected"))

  intelliframe_out@recovery_avg <- intelliframe_out@recovery |>
    dplyr::select(-.data[["Location"]]) |>
    dplyr::left_join(
      dplyr::select(intelliframe_out@recovery_avg, -.data[["Recovery"]]),
      by = c("Plate", "Group", "Well ID", "Sample ID", "Standard", "Type", "Analyte")
      ) |>
    dplyr::select(
      "Plate", "Group", "Location", "Well ID", "Sample ID", "Standard", "Type",
      "Analyte", "Recovery"
    ) |>
    dplyr::summarise(
      .by = c("Plate", "Group", "Location", "Well ID", "Sample ID", "Standard",
              "Type", "Analyte"),
      Recovery = mean(.data[["Recovery"]], na.rm = TRUE)
    )

  intelliframe_out
}
