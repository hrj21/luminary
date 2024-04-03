#' update_recovery
#'
#' Update the recovery property from an intelliframe object using up-to-date
#'   well_data. Not meant to be called by the user.
#'
#' @param .well_data A tibble containing the well_data property.
#'
#' @return An intelliframe
#' @export
#'
#' @noRd
update_recovery <- function(.well_data){
  dplyr::filter(.well_data, .data[["Type"]] %in% c("Standard", "Control")) |>

    dplyr::mutate(
      Recovery = dplyr::case_when(
        .data[["Expected"]] == 0 ~ NA_real_,
        .default = .data[["Result"]] / .data[["Expected"]]
      )
    ) |>

    dplyr::select(-c("MFI", "Result", "Messages", "Exclude Reason", "Excluded", "Expected"))
}
