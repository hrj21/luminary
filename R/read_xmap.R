#' Read data from xMAP instrument
#'
#' Read data from xMAP instrument (this is the description)
#'
#' @param file Path to the file to be read as a character string.
#'
#' @return A tibble
#' @export
#'
#' @examples
#' 1 + 1
read_xmap <- function(file) {

  metadata <- readxl::read_xlsx(
    file,
    range     = "Summary!A1:B19",
    col_names = c("Keyword", "Value")
  )

  analytes <- readxl::read_xlsx(file, sheet = "Analytes", skip = 20)

  well_data_sheets <- readxl::excel_sheets(file)[2:12]

  sheet_data <- lapply(well_data_sheets, function(x) {
    extract_sheet_data(file, sheet = x)
  }) |> stats::setNames(well_data_sheets)

  messages <- extract_sheet_data(file, sheet = "Messages", numeric_data = FALSE)
  excluded_wells <-  readxl::read_xlsx(file, sheet = "Excluded Wells", skip = 20)

  expected <- sheet_data$Expected

  joining_vars <- c(
    "Plate", "Group", "Location", "Well ID", "Sample ID", "Standard", "Type", "Analyte"
  )

  well_data <- sheet_data$MFI |>
    dplyr::left_join(sheet_data$Result, by = joining_vars) |>
    dplyr::left_join(messages,         by = joining_vars) |>
    dplyr::left_join(excluded_wells,   by = joining_vars[!joining_vars %in% c("Standard", "Type")]) |>
    dplyr::mutate(Excluded = dplyr::case_when(
      is.na(`Exclude Reason`) ~ FALSE, .default = TRUE
    )) |>
    dplyr::left_join(expected, by = joining_vars[-3], suffix = c("", ".y")) |>
    dplyr::select(-Location.y)

  summary_mfi <- sheet_data$`Avg. MFI` |>
    dplyr::left_join(sheet_data$`MFI CV`, by = joining_vars) |>
    dplyr::left_join(sheet_data$`MFI SD`, by = joining_vars) |>
    dplyr::rename("Avg" = MFI) |>
    tidyr::pivot_longer(cols = c("Avg", "CV", "SD"), names_to = "Statistic", values_to = "MFI")

  summary_result <- sheet_data$`Avg. Result` |>
    dplyr::left_join(sheet_data$`Result CV`, by = joining_vars) |>
    dplyr::left_join(sheet_data$`Result SD`, by = joining_vars) |>
    dplyr::rename("Avg" = Result) |>
    tidyr::pivot_longer(cols = c("Avg", "CV", "SD"), names_to = "Statistic", values_to = "Result")

  summary_data <- dplyr::left_join(summary_mfi, summary_result, by = c(joining_vars, "Statistic")) |>
    tidyr::pivot_wider(
      names_from = Statistic,
      names_glue = "{.value}_{Statistic}",
      values_from = c(MFI, Result)
    ) |>
    dplyr::left_join(expected, by = joining_vars)

  recovery     <- sheet_data$Recovery
  recovery_avg <- sheet_data$`Avg. Recovery`

  curve_data <- readxl::read_xlsx(
    file,
    skip = 2,
    range = readxl::cell_limits(c(3, 1), c(NA, 10), sheet = "Curve Data"),
    na    = "N/A"
  ) |>
    dplyr::filter(!is.na(.data$Group))

  intelliframe(
    metadata     = metadata,
    analytes     = analytes,
    expected     = expected,
    recovery     = recovery,
    recovery_avg = recovery_avg,
    well_data    = well_data,
    summary_data = summary_data,
    curve_data   = curve_data
  )
}
