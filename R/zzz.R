.onLoad <- function(libname, pkgname) {
  if (getRversion() < "4.3.0") {
    suppressPackageStartupMessages(requireNamespace("S7"))
  }
  S7::methods_register()
}
