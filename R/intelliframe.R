#' intelliframe class
#'
#' Defines the constructor function for the intelliframe S7 class. Not meant to be
#'   called directly by the user (see \code{\link{read_xmap}}).
#'
#' @name intelliframe-class
#' @rdname intelliframe-class
#'
#' @export intelliframe
#' @exportClass intelliframe
#'
intelliframe <- S7::new_class(
  "intelliframe",
  properties = list(
    "metadata"       = S7::class_data.frame,
    "analytes"       = S7::class_data.frame,
    "expected"       = S7::class_data.frame,
    "recovery"       = S7::class_data.frame,
    "recovery_avg"   = S7::class_data.frame,
    "well_data"      = S7::class_data.frame,
    "summary_data"   = S7::class_data.frame,
    "curve_data"     = S7::class_data.frame
  )
)
