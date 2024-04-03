#' Extract blocks of data from an xlsx file exported from Belysa
#'
#' Read an single sheet from an .xlsx file exported from the Belysa software,
#'   and return an intelliframe object. Not meant to be called by the user.
#'
#' @param file Character string with path to excel file to be read.
#' @param sheet Character string of the sheet to be read.
#' @param numeric_data Whether the data being read are numeric (default = \code{TRUE}).
#'
#' @return A tibble.
#'
#' @noRd
extract_sheet_data <- function(file, sheet, numeric_data = TRUE) {
  readxl::read_xlsx(path = file, sheet = sheet, skip = 24, na = c("-", " ")) |>
    dplyr::filter(.data$Location != "Location") |>
    dplyr::mutate(
      if(numeric_data) {
        dplyr::across(
          .cols = -c(.data$Plate, .data$Group, .data$Location, .data$`Well ID`, .data$`Sample ID`, .data$Standard),
          .fns  = as.numeric
        )},
      Type = gsub( " .*$", "", .data$Group)
    ) |>
    tidyr::pivot_longer(
      cols = -c(.data$Plate, .data$Group, .data$Location, .data$`Well ID`, .data$`Sample ID`, .data$Standard, .data$Type),
      names_to = "Analyte",
      values_to = gsub( "^.* ", "", sheet)
    )
}
