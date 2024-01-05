#' print method for intelliframe class
#'
#' @param x An intelliframe object.
#' @param max.level How many levels to print.
#' @param ... Unused.
#'
#' @exportS3Method
print.intelliframe <- function(x, max.level = 1, ...) {
  counts <- get_well_data(x) |>
    dplyr::summarise(.by = "Type", dplyr::n())

  counts <- lapply(c("Standard", "Control", "Unknown"), function(.type) {
    if(.type %in% counts$Type) {
      dplyr::filter(counts, .data[["Type"]] == .type) |> dplyr::pull(2)
    } else {
      0
    }
  }) |> setNames(c("Standard", "Control", "Unknown"))

  n_analytes <- get_analytes(x) |> nrow()

  cat(
    "Intelliframe with:\n", n_analytes, " analytes, ", counts$Standard,
    " standard samples, ", counts$Control, " control samples, and ",
    counts$Unknown, " unknown samples\n\n", sep = ""
  )

  str(x, max.level = max.level)
}
