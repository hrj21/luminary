#' something something
#'
#' @param ... blah blah blah
#' @param numeric_data blah blah blah
#'
#' @return A tibble of well data
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
          .cols = -c("Plate", "Group", "Location", "Well ID", "Sample ID", "Standard"),
          .fns  = as.numeric
        )},
      Type = gsub( " .*$", "", .data$Group)
    ) |>
    tidyr::pivot_longer(
      cols = -c(Plate, Group, Location, `Well ID`, `Sample ID`, Standard, Type),
      names_to = "Analyte",
      values_to = gsub( "^.* ", "", sheet)
    )
}
