#' Extract blocks of data from xlsx file exported from Belysa
#'
#' this is a description
#'
#' @param file Character string with path to excel file to be read.
#' @param sheet Character string of the sheet to be read.
#' @param numeric_data Whether the data being read are numeric (default = \code{TRUE}).
#'
#' @return A tibble of sheet data data.
#' @export
#'
#' @importFrom rlang .data
#'
#' @examples
#' 1 + 1
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
