#' Download all countries and regions from the World Bank API
#'
#' This function retrieves information about geographies (countries and regions) from the World Bank API.
#' It returns a tibble containing various details such as the geography's ID, ISO2 code, name, region information,
#' lending type, capital city, and coordinates.
#'
#' @param language A character string specifying the language for the API response. Defaults to `"en"` (English).
#' Other supported options include `"es"` (Spanish), `"fr"` (French), and others depending on the API.
#' @param per_page An integer specifying the number of records to fetch per request. Defaults to `1000`.
#'
#' @return A tibble with the following columns:
#' \describe{
#'   \item{geography_id}{Character string representing the geography's unique identifier.}
#'   \item{geography_iso2code}{Character string for the ISO2 country code.}
#'   \item{geography_name}{Character string for the name of the geography.}
#'   \item{geography_type}{Character string for the type of the geography ("country" or "region").}
#'   \item{region_id}{Character string representing the region's unique identifier.}
#'   \item{region_iso2code}{Character string for the ISO2 region code.}
#'   \item{region_name}{Character string for the name of the region.}
#'   \item{admin_region_id}{Character string representing the administrative region's unique identifier.}
#'   \item{admin_region_iso2code}{Character string for the ISO2 code of the administrative region.}
#'   \item{admin_region_name}{Character string for the name of the administrative region.}
#'   \item{lending_type_id}{Character string representing the lending type's unique identifier.}
#'   \item{lending_type_iso2code}{Character string for the ISO2 code of the lending type.}
#'   \item{lending_type_name}{Character string for the name of the lending type.}
#'   \item{capital_city}{Character string for the name of the capital city.}
#'   \item{longitude}{Numeric value for the longitude of the geography.}
#'   \item{latitude}{Numeric value for the latitude of the geography.}
#' }
#'
#' @details This function sends a request to the World Bank API to retrieve data for all supported geographies
#' in the specified language. The data is then processed into a tidy format and includes information about the
#' country, such as its ISO code, capital city, geographical coordinates, and additional nested metadata about
#' regions, income levels, and lending types.
#'
#' @export
#'
#' @examples
#' # Download all geographies in English
#' wdi_get_geographies(language = "en")
#'
#' # Download all geographies in Spanish
#' wdi_get_geographies(language = "zh")
#'
wdi_get_geographies <- function(language = "en", per_page = 1000) {

  geographies_raw <- perform_request("countries/all", language, per_page)

  geographies_processed <- tibble(
    geography_id = extract_values(geographies_raw, "id"),
    geography_iso2code = extract_values(geographies_raw, "iso2Code"),
    geography_name = extract_values(geographies_raw, "name"),
    region_id = extract_values(geographies_raw, "region$id"),
    region_iso2code = extract_values(geographies_raw, "region$iso2code"),
    region_name = extract_values(geographies_raw, "region$value"),
    admin_region_id = extract_values(geographies_raw, "adminregion$id"),
    admin_region_iso2code = extract_values(geographies_raw, "adminregion$iso2code"),
    admin_region_name = extract_values(geographies_raw, "adminregion$value"),
    lending_type_id = extract_values(geographies_raw, "lendingType$id"),
    lending_type_iso2code = extract_values(geographies_raw, "lendingType$iso2code"),
    lending_type_name = extract_values(geographies_raw, "lendingType$value"),
    capital_city = extract_values(geographies_raw, "capitalCity"),
    longitude = extract_values(geographies_raw, "longitude"),
    latitude = extract_values(geographies_raw, "latitude")
  ) |>
    mutate(
      across(where(is.character), ~ if_else(.x == "", NA, .x)),
      across(where(is.character), trimws),
      geography_type = if_else(.data$region_name == "Aggregates", "Region", "Country")
    ) |>
    relocate(c("geography_type", "capital_city"), .after = "geography_name")

  geographies_processed
}
