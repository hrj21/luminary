#' print method for intelliframe class
#'
#' @param intelliframe An object of class \code{intelliframe}, usually created using \code{\link{read_xmap}}.
#'
#' @name print
#'
#' @return printed summary
#'
#' @export
#'
#' @examples
#' 1+1
S7::method(print, intelliframe) <- function(x, ...) {
  "this is an intelliframe"
}
