#' Download regions from the World Bank API
#'
#' This function returns a tibble of supported regions for querying the World
#' Bank API.The regions include various geographic areas covered by the World
#' Bank's datasets.
#'
#' @param language A character string specifying the language code for the API
#'  response (default is "en" for English).
#'
#' @return A tibble with the following columns:
#' \describe{
#'   \item{region_id}{An integer identifier for each region.}
#'   \item{region_code}{A character string representing the region code.}
#'   \item{region_iso2code}{A character string representing the ISO2 code for
#'                          the region.}
#'   \item{region_name}{A character string representing the name of the region,
#'                      in the specified language.}
#' }
#'
#' @details This function provides a reference for the supported regions, which
#'  are important for refining queries related to geographic data in the World
#'  Bank's datasets. The `region_id` column is unique for seven key regions.
#'
#' @source https://api.worldbank.org/v2/region
#'
#' @export
#'
#' @examplesIf curl::has_internet()
#' # Download all regions
#' wdi_get_regions()
#'
wdi_get_regions <- function(language = "en") {

  regions_raw <- perform_request("region", language)

  # id is non-missing for 7 entries
  regions_processed <- as_tibble(regions_raw) |>
    mutate(id = as.integer(.data$id)) |>
    select(region_id = "id",
           region_code = "code",
           region_iso2code = "iso2code",
           region_name = "name") |>
    mutate(across(where(is.character), trimws))

  regions_processed
}
