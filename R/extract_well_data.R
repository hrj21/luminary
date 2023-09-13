#' Title
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
extract_well_data <- function(..., numeric_data = TRUE) {
  readxl::read_xlsx(..., skip = 24, na = c("-", " ")) |>
    dplyr::filter(.data$Location != "Location") |>
    dplyr::mutate(
      if(numeric_data) {
        dplyr::across(
          .cols = -c(.data$Plate, .data$Group, .data$Location, .data$`Well ID`, .data$`Sample ID`, .data$Standard),
          .fns  = as.numeric
        )},
      Type = gsub( " .*$", "", .data$Group)
    )
}
