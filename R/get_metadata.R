#' Extract instrument metadata from intelliframe
#'
#' Convenience function to extract instrument metadata from an intelliframe object
#'
#' @param .data
#'
#' @return A tibble
#' @export
#'
#' @examples
#' 1+1
get_metadata <- function(.data) {
  S7::`@`(.data, metadata)
}
