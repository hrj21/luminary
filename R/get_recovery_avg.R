#' Extract the table of average standard recoveries from intelliframe
#'
#' Convenience function to extract the table of average standard recoveries from an intelliframe object
#'
#' @param .intelliframe An intelliframe object.
#'
#' @return A tibble
#' @export
#'
#' @examples
#' 1+1
get_recovery_avg <- function(.intelliframe) {
  S7::`@`(.intelliframe, "recovery_avg")
}

