#' Download data sources from the World Bank API
#'
#' This function returns a tibble of supported data sources for querying the World Bank API.
#' The data sources include various databases and datasets provided by the World Bank.
#'
#' @param language A character string specifying the language code for the API response (default is "en" for English).
#'
#' @return A tibble with six columns:
#' \describe{
#'   \item{id}{The unique identifier for the data source.}
#'   \item{name}{The name of the data source (e.g., "World Development Indicators").}
#'   \item{update_date}{The last update date of the data source.}
#'   \item{is_data_available}{A boolean indicating whether data is available.}
#'   \item{is_metadata_available}{A boolean indicating whether metadata is available.}
#'   \item{concepts}{The number of concepts defined for the data source.}
#' }
#'
#' @details This function provides a reference for the supported data sources and their metadata when querying
#' the World Bank API. The columns `is_data_available` and `is_metadata_available` are logical values
#' derived from the API response, where "Y" indicates availability.
#'
#' @source https://api.worldbank.org/v2/sources
#'
#' @export
#'
#' @examples
#' # Download all supported data sources
#' wdi_get_sources()
#'
wdi_get_sources <- function(language = "en") {

  sources_raw <- perform_request("sources", language)

  # url and description are always empty, hence omitted
  sources_processed <- bind_rows(sources_raw) |>
    select(source_id = id,
           source_name = name,
           update_date = lastupdated,
           is_data_available = dataavailability,
           is_metadata_available = metadataavailability,
           concepts) |>
    mutate(across(c(is_data_available, is_metadata_available), ~ . == "Y"),
           update_date = as.Date(update_date),
           across(c(source_id, concepts), as.integer))

  sources_processed
}
