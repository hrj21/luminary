.onAttach <- function(libname, pkgname) {
  if (getRversion() < "4.3.0")
    requireNamespace("S7")
  S7::methods_register()
}
