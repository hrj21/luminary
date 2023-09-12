#' intelliframe class
#'
#' Defines the constructor function for the intelliframe S7 class. Not meant to be
#'   called directly by the user (see \code{\link{read_xmap}}).
#'
#'@slot metadata is this how I describe each of the properties?
#'
#'@export
#'
intelliframe <- S7::new_class(
  "intelliframe",
  properties = list(
    "metadata"       = S7::class_data.frame,
    "summary"        = S7::class_data.frame,
    "expected"       = S7::class_data.frame,
    "mfi"            = S7::class_data.frame,
    "mfi_avg"        = S7::class_data.frame,
    "mfi_cv"         = S7::class_data.frame,
    "mfi_sd"         = S7::class_data.frame,
    "result"         = S7::class_data.frame,
    "result_avg"     = S7::class_data.frame,
    "result_cv"      = S7::class_data.frame,
    "result_sd"      = S7::class_data.frame,
    "recovery"       = S7::class_data.frame,
    "recovery_avg"   = S7::class_data.frame,
    "messages"       = S7::class_data.frame,
    "curve_data"     = S7::class_data.frame,
    "analytes"       = S7::class_data.frame,
    "excluded_wells" = S7::class_data.frame
  )
)
