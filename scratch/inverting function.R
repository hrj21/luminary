joined <- dplyr::left_join(
  get_well_data(v),
  get_curve_data(v)[, c("Analyte", "Equation")],
  by = "Analyte"
)


curve_data <- S7::`@`(v, "curve_data")
functions <- gsub("x", ".x", curve_data$Equation)
functions <- gsub("y = ", "", functions)
names(functions) <- curve_data$Analyte

inverse <- function(f, lower, upper){
  function(y){
    uniroot(function(x){f(x) - y}, lower = lower, upper = upper)[[1]]
  }
}

f <- reformulate(functions[1]) |> rlang::as_function()

inverse_f <- inverse(f, 0, 1e8)
inverse_f(f(10^4))

lapply(names(functions), function(analyte) {
  df <- dplyr::filter(v@well_data, Analyte == analyte)
  f <- reformulate(functions[analyte]) |> rlang::as_function()
  inverse_f <- inverse(f, 0, 1e8)
  inverse_f(f(10^4))
})
