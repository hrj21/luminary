#' Extract the table of expected concentrations from intelliframe
#'
#' Convenience function to extract the table of expected standard concentrations from an intelliframe object
#'
#' @param .intelliframe An intelliframe object.
#'
#' @return A tibble
#' @export
#'
#' @examples
#' 1+1
get_expected <- function(.intelliframe) {
  S7::prop(.intelliframe, "expected")
}
