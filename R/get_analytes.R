#' Extract the table of analytes from intelliframe
#'
#' Convenience function to extract the table of analytes from an intelliframe object
#'
#' @param .intelliframe An intelliframe object.
#'
#' @return A tibble
#' @export
#'
#' @examples
#' 1+1
get_analytes <- function(.intelliframe) {
  S7::prop(.intelliframe, "analytes")
}
