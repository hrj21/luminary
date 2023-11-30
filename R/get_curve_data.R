#' Extract the standard curve data from intelliframe
#'
#' Convenience function to extract the standard curve data from an intelliframe object
#'
#' @param .data
#'
#' @return A tibble
#' @export
#'
#' @examples
#' 1+1
get_curve_data <- function(.data) {
  S7::`@`(.data, curve_data)
}

