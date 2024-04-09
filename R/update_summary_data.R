#' update_summary_data
#'
#' Update the summary_data property from an intelliframe object using up-to-date
#'   well_data Not meant to be called by the user.
#'
#' @param .well_data A tibble containing the well_data property.
#' @param .summary_data A tibble containing the original summary_data property.
#' @param .use_excluded Logical flag indicating whether wells with a value of
#'   \code{TRUE} in the \code{Excluded} column are used to calculate summary
#'   statistics.
#' @param .excluded_wells Logical vector indicating whether each well is
#'   excluded.
#'
#' @return A tibble
#'
update_summary_data <- function(.well_data, .summary_data, .use_excluded, .excluded_wells) {
  correct_location <- dplyr::select(.well_data, -Location) |>
    dplyr::left_join(
      dplyr::select(.summary_data, -c("Expected", dplyr::contains("MFI"), dplyr::contains("Result"))),
      by = c("Plate", "Group", "Well ID", "Sample ID", "Standard", "Type", "Analyte")
    ) |>
    dplyr::select(
      "Plate", "Group", "Location", "Well ID", "Sample ID", "Standard", "Type",
      "Analyte", "MFI", "Result", "Expected"
    )

  if(!.use_excluded) {
    correct_location <- correct_location[-.excluded_wells, ]
  }

  dplyr::summarise(
    correct_location,
    .by = c("Plate", "Group", "Location", "Well ID", "Sample ID", "Standard",
            "Type", "Analyte", "Expected"),
    MFI_Avg    = mean(MFI, na.rm = TRUE),
    MFI_SD     =   ifelse(dplyr::n() == 1, 0, sd(MFI, na.rm = TRUE)),
    MFI_CV     =   ifelse(dplyr::n() == 1, 0, MFI_SD / MFI_Avg),
    Result_Avg = mean(Result, na.rm = TRUE),
    Result_SD  =   ifelse(dplyr::n() == 1, 0, sd(Result, na.rm = TRUE)),
    Result_CV  =   ifelse(dplyr::n() == 1, 0, Result_SD / Result_Avg)
  ) |>
    dplyr::select(
      "Plate", "Group", "Location", "Well ID", "Sample ID", "Standard", "Type",
      "Analyte", "MFI_Avg", "MFI_CV", "MFI_SD", "Result_Avg", "Result_CV",
      "Result_SD", "Expected"
    )
}
