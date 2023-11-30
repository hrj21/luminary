#' Extract the table of average standard recoveries from intelliframe
#'
#' Convenience function to extract the table of average standard recoveries from an intelliframe object
#'
#' @param .data
#'
#' @return A tibble
#' @export
#'
#' @examples
#' 1+1
get_recovery_avg <- function(.data) {
  S7::`@`(.data, recovery_avg)
}

