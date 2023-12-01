library(nplr)

standards <- get_well_data(v) |>
  dplyr::filter(Type == "Standard")

expected <- get_expected(v) |>
  select(Plate, Group, `Well ID`, `Sample ID`, Standard, Type, Analyte, Expected)

standard_list <- left_join(
  standards,
  expected,
  by = c("Plate", "Group", "Well ID", "Sample ID", "Standard", "Type", "Analyte", "Expected")
)

standard_list <- split(standard_list, standard_list$Analyte)


fits <- lapply(standard_list, function(analyte) {
  non_zero <- ifelse(analyte$Expected < 1, analyte$Expected + 0.01, analyte$Expected)
  fit <- nplr(
    x      = non_zero,
    y      = analyte$MFI/max(analyte$MFI),
    npars  = "all",
    silent = FALSE
  )
})

names(fits) <- names(standard_list)

well_data <- get_well_data(v)

refitted <- lapply(names(fits), function(analyte) {
  maximum <- max(standard_list[[analyte]]$MFI)
  dplyr::filter(well_data, Analyte == analyte) |>
    mutate(Result = getEstimates(fits[[analyte]], targets = MFI / maximum)$x)
}) |> dplyr::bind_rows()


