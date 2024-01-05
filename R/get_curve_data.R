#' Extract the standard curve data from intelliframe
#'
#' Convenience function to extract the standard curve data from an intelliframe object
#'
#' @param .intelliframe An intelliframe object.
#'
#' @return A tibble
#' @export
#'
#' @examples
#' 1+1
get_curve_data <- function(.intelliframe) {
  S7::`@`(.intelliframe, "curve_data")
}

