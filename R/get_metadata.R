#' Extract instrument metadata from intelliframe
#'
#' Convenience function to extract instrument metadata from an intelliframe object
#'
#' @param .intelliframe An intelliframe object.
#'
#' @return A tibble
#' @export
#'
#' @examples
#' 1+1
get_metadata <- function(.intelliframe) {
  S7::prop(.intelliframe, "metadata")
}
