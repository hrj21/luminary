#' Extract the table of analytes from intelliframe
#'
#' Convenience function to extract the table of analytes from an intelliframe object
#'
#' @param .data
#'
#' @return A tibble
#' @export
#'
#' @examples
#' 1+1
get_analytes <- function(.data) {
  S7::`@`(.data, analytes)
}
