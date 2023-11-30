#' Extract the table of standard recoveries from intelliframe
#'
#' Convenience function to extract the table of standard recoveries from an intelliframe object
#'
#' @param .data
#'
#' @return A tibble
#' @export
#'
#' @examples
#' 1+1
get_recovery <- function(.data) {
  S7::`@`(.data, recovery)
}
