# Install Package: 'Ctrl + Shift + B'
# Check package:   'Ctrl + Shift + E'
# Test Package:    'Ctrl + Shift + T'

library(devtools)
library(usethis)
library(testthat)

# usethis::create_package("~/Desktop/cabinet")
# usethis::use_r("read_xmap")
# usethis::use_package_doc()
# usethis::use_vignette("Working-with-xMAP-data")
# use_package("ggplot2")
# usethis::use_testthat()
# usethis::use_test("read_xmap")
# usethis::use_code_of_conduct("hefin.i.rhys@gmail.com")

devtools::document()
devtools::test()