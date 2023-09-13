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

  summary <- readxl::read_xlsx(
    file,
    sheet = "Summary",
    skip  = 20,
    na    = "-"
  )

  well_data_sheets <- readxl::excel_sheets(file)[2:12]

  well_data <- lapply(well_data_sheets, function(x) {
    extract_well_data(file, sheet = x)
  }) |> stats::setNames(well_data_sheets)

  expected     <- well_data$Expected
  mfi          <- well_data$MFI
  mfi_avg      <- well_data$`Avg. MFI`
  mfi_cv       <- well_data$`MFI CV`
  mfi_sd       <- well_data$`MFI SD`
  result       <- well_data$Result
  result_avg   <- well_data$`Avg. Result`
  recovery     <- well_data$Recovery
  recovery_avg <- well_data$`Avg. Recovery`
  result_cv    <- well_data$`Result CV`
  result_sd    <- well_data$`Result SD`

  messages <- extract_well_data(file, sheet = "Messages", numeric_data = FALSE)

  curve_data <- readxl::read_xlsx(
    file,
    skip = 2,
    range = readxl::cell_limits(c(3, 1), c(NA, 10), sheet = "Curve Data"),
    na    = "N/A"
  ) |>
    dplyr::filter(!is.na(.data$Group))

  analytes <- readxl::read_xlsx(file, sheet = "Analytes", skip = 20)

  excluded_wells <-  readxl::read_xlsx(file, sheet = "Excluded Wells", skip = 20)

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
