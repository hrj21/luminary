#' update_recovery_avg
#'
#' Update the recovery_avg property from an intelliframe object using up-to-date
#'   recovery. Not meant to be called by the user.
#'
#' @param .recovery A tibble containing the recovery property.
#' @param .recovery A tibble containing the original recovery_avg property.
#' @param .use_excluded Logical flag indicating whether wells with a value of
#'   \code{TRUE} in the \code{Excluded} column are used to calculate summary
#'   statistics.
#' @param .excluded_wells Logical vector indicating whether each well is
#'   excluded.
#'
#' @return A tibble
#'
update_recovery_avg <- function(.recovery, .recovery_avg, .use_excluded, .excluded_wells) {
  correct_location <- dplyr::select(.recovery, -Location) |>
    dplyr::left_join(
      dplyr::select(.recovery_avg, -Recovery),
      by = c("Plate", "Group", "Well ID", "Sample ID", "Standard", "Type", "Analyte")
    ) |>
    dplyr::select(
      "Plate", "Group", "Location", "Well ID", "Sample ID", "Standard", "Type",
      "Analyte", "Recovery"
    )

  if(!.use_excluded) {
    correct_location <- correct_location[-.excluded_wells, ]
  }

  dplyr::summarise(
    correct_location,
    .by = c("Plate", "Group", "Location", "Well ID", "Sample ID", "Standard",
            "Type", "Analyte"),
    Recovery = mean(Recovery, na.rm = TRUE)
  )
}
