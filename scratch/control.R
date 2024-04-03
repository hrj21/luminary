# Install Package: 'Ctrl + Shift + B'
# Check package:   'Ctrl + Shift + E'
# Test Package:    'Ctrl + Shift + T'

# library(devtools)
# library(usethis)
# library(testthat)
# library(pkgdown)


# Use once ----------------------------------------------------------------
# usethis::create_package()
# usethis::create_from_github()
# usethis::use_package_doc()
# usethis::use_vignette("Working-with-xMAP-data")
# usethis::use_testthat()
# usethis::use_code_of_conduct("hefin.i.rhys@gmail.com")
# usethis::create_github_token()
# usethis::edit_r_environ()
# usethis::use_logo("inst/figures/luminary.png")
# usethis::use_github_actions()


# Use regularly -----------------------------------------------------------
usethis::use_package("S7")
usethis::use_r("update_summary_data")
usethis::use_test("update_summary_data")

# Use often ---------------------------------------------------------------
# v <- read_xmap("C:/Users/u061745/Downloads/U20plex_plate1_Belysa_MHF.xlsx")
v <- read_xmap("C:/Users/u061745/Downloads/U5plex_plate1_Belysa_MHF.xlsx")
devtools::document()
devtools::test()
devtools::check()
pkgdown::build_site()


