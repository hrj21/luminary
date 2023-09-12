#' Title
#'
#' @param ... blah blah blah
#' @param numeric_data
#'
#' @return A tibble of well data
#' @export
#'
#' @examples
#' blah
extract_well_data <- function(..., numeric_data = TRUE) {
  readxl::read_xlsx(..., skip = 24, na = c("-", " ")) |>
    dplyr::filter(Location != "Location") |>
    dplyr::mutate(
      if(numeric_data) {dplyr::across(.cols = -c(Plate, Group, Location, `Well ID`, `Sample ID`, Standard), as.numeric)},
      Type = gsub( " .*$", "", Group)
    )
}
