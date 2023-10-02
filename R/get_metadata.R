#' Extract instrument metadata from intelliframe
#'
#' @param .data
#'
#' @return
#' @export
#'
#' @examples
get_metadata <- function(.data) {
  S7::`@`(.data, metadata)
}
