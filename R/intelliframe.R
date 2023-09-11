#' intelliframe class
#'
#' Defines the constructor function for the intelliframe S7 class. Not meant to be
#'   called directly by the user (see \code{\link{read_xmap}}).
#'
#' @param metadata List of metadata exported by the instrument.
#' @param summary Data frame of interpolated values, averaged across replicates.
#' @param expected Data frame of true values of standards and controls.
#' @param mfi Data frame of raw MFI values.
#' @param mfi_avg Data frame of raw MFI values, averaged across replicates.
#' @param mfi_cv Data frame of coefficient of variation of raw MFI values.
#' @param mfi_sd Data frame of standard deviation of raw MFI values.
#' @param result Data frame of interpolated values.
#' @param result_avg Data frame of interpolated values, averaged across replicates.
#' @param result_cv Data frame of coefficient of variation of interpolated values.
#' @param result_sd Data frame of standard deviation of interpolated values.
#' @param recovery Data frame of interpolated value as a percentage of true values.
#' @param recovery_avg Data frame of interpolated value as a percentage of true values, averaged across replicates.
#' @param messages Data frame of well messages.
#' @param curve_data Data frame of fitted curve data.
#' @param analytes Data frame of analyte metadata.
#' @param excluded_wells Data.frame of wells recorded but not included in analysis.
#'
#' @return intelliframe S7 object
#' @export
#'
intelliframe <- function(metadata, summary, expected, mfi, mfi_avg, mfi_cv,
                         mfi_sd, result, result_avg, result_cv, result_sd,
                         recovery, recovery_avg, messages, curve_data, analytes,
                         excluded_wells) {

  intelliframe <- new_class(
    "intelliframe",
    properties = list(
      metadata       = class_list,
      summary        = class_data.frame,
      expected       = class_data.frame,
      mfi            = class_data.frame,
      mfi_avg        = class_data.frame,
      mfi_cv         = class_data.frame,
      mfi_sd         = class_data.frame,
      result         = class_data.frame,
      result_avg     = class_data.frame,
      result_cv      = class_data.frame,
      result_sd      = class_data.frame,
      recovery       = class_data.frame,
      recovery_avg   = class_data.frame,
      messages       = class_data.frame,
      curve_data     = class_data.frame,
      analytes       = class_data.frame,
      excluded_wells = class_data.frame
    )
  )

  intelliframe(
    metadata       = metadata,
    summary        = summary,
    expected       = expected,
    mfi            = mfi,
    mfi_avg        = mfi_avg,
    mfi_cv         = mfi_cv,
    mfi_sd         = mfi_sd,
    result         = result,
    result_avg     = result_avg,
    result_cv      = result_cv,
    result_sd      = result_sd,
    recovery       = recovery,
    recovery_avg   = recovery_avg,
    messages       = messages,
    curve_data     = curve_data,
    analytes       = analytes,
    excluded_wells = excluded_wells
  )
}
