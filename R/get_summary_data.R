#' Extract summary data from intelliframe object
#'
#' Convenience function to extract summary data from an intelliframe object
#'
#' @param .intelliframe An intelliframe object.
#'
#' @return A tibble
#' @export
#'
#' @examples
#' 1+1
get_summary_data <- function(.intelliframe) {
  S7::prop(.intelliframe, "summary_data")
}
