#' Extract individual well data from intelliframe object
#'
#' Convenience function to extract individual well data from an intelliframe object
#'
#' @param .intelliframe An intelliframe object.
#'
#' @return A tibble
#' @export
#'
#' @examples
#' 1+1
get_well_data <- function(.intelliframe) {
  S7::prop(.intelliframe, "well_data")
}
