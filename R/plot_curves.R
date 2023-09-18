#' Plot standard curves with interpolated values
#'
#' @param .data
#' @param type
#' @param interactive
#' @param point_size
#' @param ...
#'
#' @return ggplot object
#' @export
#'
#' @examples
#' 1 + 1
plot_curves <- function(.data, type = "individual", interactive = FALSE, facet_scales = "fixed", point_size = 3, ...) {
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
  curve_data_long <- curve_data |>
    tidyr::pivot_longer(c(LLoQ, MDD, LoD), names_to = "Limit", values_to = "value")

  text_heights <- dplyr::summarise(dat, .by = Analyte, Max = max(MFI))

  curve_data_long <- dplyr::left_join(curve_data_long, text_heights, by = "Analyte") |>
    dplyr::mutate(n = dplyr::row_number(), text_height = Max / n, .by = Analyte)

  functions <- gsub("x", ".x", curve_data$Equation)
  functions <- gsub("y = ", "", functions)
  names(functions) <- curve_data$Analyte

  simulated_data <- lapply(curve_data$Analyte, function(x)  {
    f <- reformulate(functions[x]) |> rlang::as_function()
    d <- dplyr::filter(dat, Analyte == x)
    max_conc <- log10(max(d$Result, na.rm = TRUE) * 2)
    data.frame(
      Analyte = x,
      Result  = 10^seq(-1, max_conc, length.out = 1000)
    ) |> dplyr::mutate(Predicted = f(Result))
  }) |> dplyr::bind_rows()

  p <- ggplot2::ggplot(mapping = ggplot2::aes(col = Type)) +
    ggplot2::geom_line(data = simulated_data, ggplot2::aes(Result, Predicted), inherit.aes = FALSE) +
    ggplot2::geom_vline(data = curve_data_long, ggplot2::aes(xintercept = value), col = "black", linetype = "dashed") +
    ggplot2::geom_text(data = curve_data_long, ggplot2::aes(x = 1.2 * (value + 1), y = text_height, label = Limit), angle = 0, hjust = 0, col = "black") +
    ggplot2::scale_colour_brewer(type = "qual", palette = "Set1") +
    ggplot2::geom_point(data = standard_data, ggplot2::aes(Expected, MFI), size = point_size) +
    ggplot2::geom_point(data = experimental_data, ggplot2::aes(Result, MFI), size = point_size) +
    ggplot2::geom_rug(data = experimental_data, ggplot2::aes(Result, MFI), alpha = 0.3) +
    ggplot2::facet_wrap(~ Analyte, scales = facet_scales) +
    ggplot2::labs(x = "Expected/interpolated concentration (pg/mL)", y = "MFI") +
    ggplot2::theme_test()

  if(interactive) {
    p <- p + ggplot2::scale_x_continuous(breaks = 10^(0:7), trans = scales::pseudo_log_trans(base = 10))
    plotly::ggplotly(p, dynamicTicks = FALSE)
  } else {
    p + ggplot2::scale_x_continuous(breaks = 10^(0:7), labels = scales::label_log(), trans = scales::pseudo_log_trans(base = 10))
  }
}



