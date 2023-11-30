#' Extract the table of expected concentrations from intelliframe
#'
#' Convenience function to extract the table of expected standard concentrations from an intelliframe object
#'
#' @param .data
#'
#' @return A tibble
#' @export
#'
#' @examples
#' 1+1
get_expected <- function(.data) {
  S7::`@`(.data, expected)
}
