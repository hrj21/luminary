#' Extract summary data from intelliframe object
#'
#' Convenience function to extract summary data from an intelliframe object
#'
#' @param .data
#'
#' @return A tibble
#' @export
#'
#' @examples
#' 1+1
get_summary_data <- function(.data) {
  S7::`@`(.data, summary_data)
}
