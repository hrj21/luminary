plot_curves <- function(.data, type = "individual", interactive = FALSE, ...) {
  stopifnot("data argument must be an intelliframe object" = S7::S7_inherits(.data, intelliframe))

  if(type == "individual") {
    dat <- S7::`@`(.data, "well_data")
  } else {
    dat <- S7::`@`(.data, "summary_data") |>
      dplyr::rename("MFI" = MFI_Avg, "Result" = Result_Avg)
  }

  standard_data <- dplyr::filter(dat, Type == "Standard")
  experimental_data <- dplyr::filter(dat, Type != "Standard") |>
    dplyr::arrange(desc(Type))

  curve_data <- S7::`@`(.data, "curve_data")

  functions <- gsub("x", ".x", curve_data$Equation)
  functions <- gsub("y = ", "", functions)
  names(functions) <- curve_data$Analyte

  simulated_values <- data.frame(
    Analyte = rep(curve_data$Analyte, each = 1000),
    Result  = rep(10^seq(-1, 6, length.out = 1000), length(curve_data$Analyte))
  )

  simulated_values$MFI <- lapply(curve_data$Analyte, function(x) {
    f <- reformulate(functions[x]) |> rlang::as_function()
    f(10^seq(-1, 6, length.out = 1000))
  }) |> unlist()

  p <- ggplot2::ggplot(mapping = ggplot2::aes(col = Type)) +
    ggplot2::geom_line(data = simulated_values, ggplot2::aes(Result, MFI), inherit.aes = FALSE) +
    ggplot2::geom_point(data = standard_data, ggplot2::aes(Expected, MFI)) +
    ggplot2::geom_point(data = experimental_data, ggplot2::aes(Result, MFI),) +
    ggplot2::facet_wrap(~ Analyte, scales = "free", ...) +
    # ggplot2::scale_x_log10() +
    ggplot2::scale_x_continuous(trans=scales::pseudo_log_trans(base = 10)) +
    ggplot2::labs(x = "Expected/interpolated concentration (pg/mL)") +
    ggplot2::theme_test()

  if(interactive) {
    plotly::ggplotly(p, dynamicTicks = TRUE)
  } else {
    p
  }
}

