#' List supported regions for the World Bank API
#'
#' This function returns a tibble of supported regions for querying the World Bank API.
#' The regions include various geographic areas covered by the World Bank's datasets.
#'
#' @param language A character string specifying the language code for the API response (default is "en" for English).
#'
#' @return A tibble with several columns, including:
#' \describe{
#'   \item{id}{The unique identifier for the region (non-missing for 7 entries).}
#'   \item{other_columns}{Other columns returned by the API, depending on the structure of the data.}
#' }
#'
#' @details This function provides a reference for the supported regions, which are important for refining
#' queries related to geographic data in the World Bank's datasets. The `id` column is unique for seven key regions.
#'
#' @source https://api.worldbank.org/v2/region
#'
#' @export
#'
#' @examples
#' # List all supported regions
#' list_supported_regions()
#'
list_supported_regions <- function(language = "en") {

  regions_raw <- perform_request("region", language)

  # id is non-missing for 7 entries
  regions_processed <- bind_rows(regions_raw) |>
    mutate(id = as.integer(id))

  regions_processed
}
