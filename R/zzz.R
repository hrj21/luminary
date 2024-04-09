.onLoad <- function(libname, pkgname) {

  if (getRversion() < "4.3.0") {
    suppressPackageStartupMessages(require("S7"))
  }

  S7::methods_register()
}
