#' str method for intelliframe class
#'
#' @exportS3Method
str.intelliframe <- function(.data, ..., nest.lev = 0) {
  cat(if (nest.lev > 0) " ")

  if (nest.lev == 0) {
    S7:::str_nest(props(.data), "@", ..., nest.lev = nest.lev)
  }
}
