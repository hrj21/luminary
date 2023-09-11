.onAttach <- function(libname, pkgname) {
  if (getRversion() < "4.3.0")
    require(S7)
  S7::methods_register()
}
