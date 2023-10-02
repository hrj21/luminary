#' Extract individual well data from intelliframe object
#'
#' Convenience function to extract individual well data from an intelliframe object
#'
#' @param .data
#'
#' @return A tibble
#' @export
#'
#' @examples
#' 1+1
get_well_data <- function(.data) {
  S7::`@`(.data, well_data)
}
