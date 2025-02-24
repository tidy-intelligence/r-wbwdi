#' Download all countries and regions from the World Bank API
#'
#' This function retrieves information about geographies (countries and regions)
#' from the World Bank API. It returns a tibble containing various details such
#' as the geography's ID, ISO2 code, name, region information, lending type,
#' capital city, and coordinates.
#'
#' @param language A character string specifying the language for the API
#'  response. Defaults to `"en"` (English). Other supported options include
#'  `"es"` (Spanish), `"fr"` (French), and others depending on the API.
#' @param per_page An integer specifying the number of records to fetch per
#'  request. Defaults to `1000`.
#'
#' @return A tibble with the following columns:
#' \describe{
#'   \item{geography_id}{A character string representing the geography's unique
#'                       identifier.}
#'   \item{geography_name}{A character string for the name of the geography.}
#'   \item{geography_iso2code}{A character string for the ISO2 country code.}
#'   \item{geography_type}{A character string for the type of the geography
#'                         ("country" or "region").}
#'   \item{region_id}{A character string representing the region's unique
#'                    identifier.}
#'   \item{region_name}{A character string for the name of the region.}
#'   \item{region_iso2code}{A character string for the ISO2 region code.}
#'   \item{admin_region_id}{A character string representing the administrative
#'                          region's unique identifier.}
#'   \item{admin_region_name}{A character string for the name of the
#'                            administrative region.}
#'   \item{admin_region_iso2code}{A character string for the ISO2 code of the
#'                                administrative region.}
#'   \item{income_level_id}{A character string representing the geography's
#'                          income level.}
#'   \item{income_level_name}{A character string for the name of the
#'                            income level.}
#'   \item{income_level_iso2code}{A character string for the ISO2 code of the
#'                                income level.}
#'   \item{lending_type_id}{A character string representing the lending type's
#'                          unique identifier.}
#'   \item{lending_type_name}{A character string for the name of the lending
#'                            type.}
#'   \item{lending_type_iso2code}{A character string for the ISO2 code of the
#'                                lending type.}
#'   \item{capital_city}{A character string for the name of the capital city.}
#'   \item{longitude}{A numeric value for the longitude of the geography.}
#'   \item{latitude}{A numeric value for the latitude of the geography.}
#' }
#'
#' @details This function sends a request to the World Bank API to retrieve data
#' for all supported geographies in the specified language. The data is then
#' processed into a tidy format and includes information about the country,
#' such as its ISO code, capital city, geographical coordinates, and additional
#' metadata about regions, income levels, and lending types.
#'
#' @export
#'
#' @examplesIf curl::has_internet()
#' # Download all geographies in English
#' wdi_get_geographies()
#'
#' # Download all geographies in Spanish
#' wdi_get_geographies(language = "zh")
#'
wdi_get_geographies <- function(language = "en", per_page = 1000) {

  geographies_raw <- perform_request("countries/all", language, per_page)

  geographies_processed <- geographies_raw |>
    as_tibble() |>
    rename(
      geography_id = "id",
      geography_iso2code = "iso2Code",
      geography_name = "name"
    ) |>
    unnest_wider("region") |>
    rename(
      region_id = "id",
      region_iso2code = "iso2code",
      region_name = "value"
    ) |>
    unnest_wider("adminregion") |>
    rename(
      admin_region_id = "id",
      admin_region_iso2code = "iso2code",
      admin_region_name = "value"
    ) |>
    unnest_wider("incomeLevel") |>
    rename(
      income_level_id = "id",
      income_level_iso2code = "iso2code",
      income_level_name = "value"
    ) |>
    unnest_wider("lendingType") |>
    rename(
      lending_type_id = "id",
      lending_type_iso2code = "iso2code",
      lending_type_name = "value",
      capital_city = "capitalCity"
    ) |>
    mutate(
      longitude = if_else(
        .data$longitude == "", NA_real_, as.numeric(.data$longitude)
      ),
      latitude = if_else(
        .data$latitude == "", NA_real_, as.numeric(.data$latitude)
      ),
      geography_type = if_else(
        .data$region_name == "Aggregates", "aggregates", "country"
      ),
      across(where(is.character), ~ if_else(.x == "", NA, .x)),
      across(where(is.character), trimws)
    ) |>
    relocate(c("geography_type", "capital_city"), .after = "geography_iso2code")

  geographies_processed
}
