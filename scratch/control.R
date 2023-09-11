# Install Package: 'Ctrl + Shift + B'
# Check package:   'Ctrl + Shift + E'
# Test Package:    'Ctrl + Shift + T'

library(devtools)
library(usethis)
library(testthat)
library(pkgdown)

# usethis::create_package()
# usethis::create_from_github()
# usethis::use_package_doc()
# usethis::use_vignette("Working-with-xMAP-data")
# use_package("S7")
# usethis::use_testthat()
# usethis::use_test("read_xmap")
# usethis::use_code_of_conduct("hefin.i.rhys@gmail.com")
# usethis::create_github_token()
# usethis::edit_r_environ()
# usethis::use_logo("inst/figures/luminary.png")

# usethis::use_r("intelliframe")

devtools::document()
devtools::test()
pkgdown::build_site()


