#' str method for intelliframe class
#'
#' @param object An intelliframe object.
#' @param nest.lev How many levels to print.
#' @param ... Unused.
#'
#' @exportS3Method
str.intelliframe <- function(object, nest.lev = 0, ...) {
  cat(if (nest.lev > 0) " ")

  if (nest.lev == 0) {
    object     <- S7::props(object)
    prefix     <- "@"
    indent.str <- paste(rep.int(" ", max(0, nest.lev + 1)), collapse = "..")
    nest.lev   <- nest.lev
    names      <- format(names(object))
    for(i in seq_along(object)) {
      cat(indent.str, prefix, " ", names[[i]], ":",  sep = "")
      xi <- object[[i]]
      str(xi, ..., nest.lev = nest.lev + 1)
    }
  }
}
