#' update_well_data
#'
#' Update the well_data property from an intelliframe object using a list of
#'   model fits. Not meant to be called by the user.
#'
#' @param .well_data A tibble containing the well_data property.
#' @param .fits A list of model fits.
#' @param .standard_list A tibble of standard curve data.
#' @param .silent Logical flag indicating whether warnings and messages during
#' interpolation should be silenced.
#'
#' @return A tibble
#'
update_well_data <- function(.well_data, .fits, .standard_list, .silent) {
  lapply(names(.fits), function(analyte) {

    maximum <- max(.standard_list[[analyte]]$MFI)

    analyte_data <- dplyr::filter(.well_data, .data[["Analyte"]] == analyte)

    if(.silent) {
      suppressWarnings({
        suppressMessages({
          analyte_data$Result <- nplr::getEstimates(
            .fits[[analyte]],
            targets = analyte_data$MFI / maximum
          )$x
        })
      })
    } else {
      analyte_data$Result <- nplr::getEstimates(
        .fits[[analyte]],
        targets = analyte_data$MFI / maximum
      )$x
    }

    analyte_data
  }) |> dplyr::bind_rows()
}
