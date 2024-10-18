#' Download all countries and regions from the World Bank API
#'
#' This function retrieves and processes a list of all countries supported by the World Bank API,
#' along with metadata such as region, administrative region, income level, and lending type.
#' The user can specify the language of the API response.
#'
#' @param language A character string specifying the language for the request, see \link{wdi_get_languages}. Defaults to `"en"`.
#' @param per_page An integer specifying the number of results per page for the API. Defaults to 1000.
#' Must be a value between 1 and 32,500.
#'
#' @return A tibble containing country information along with associated metadata. The tibble includes the following columns:
#' \describe{
#'   \item{id}{The identifier for the country.}
#'   \item{iso2_code}{The ISO 2-character country code.}
#'   \item{name}{The full name of the country.}
#'   \item{capital_city}{The capital city of the country.}
#'   \item{longitude}{The longitude of the country.}
#'   \item{latitude}{The latitude of the country.}
#'   \item{regions}{A nested tibble containing information about the region the country belongs to.}
#'   \item{admin_regions}{A nested tibble containing information about the administrative region the country belongs to.}
#'   \item{income_levels}{A nested tibble containing information about the income level classification of the country.}
#'   \item{lending_types}{A nested tibble containing information about the lending type classification of the country.}
#' }
#'
#' @details This function sends a request to the World Bank API to retrieve data for all supported countries
#' in the specified language. The data is then processed into a tidy format and includes information about the
#' country, such as its ISO code, capital city, geographical coordinates, and additional nested metadata about
#' regions, income levels, and lending types.
#'
#' @export
#'
#' @examples
#' # Download all countries in English
#' wdi_get_countries(language = "en")
#'
#' # Download all countries in Spanish
#' wdi_get_countries(language = "zh")
#'
wdi_get_countries <- function(language = "en", per_page = 1000) {

  countries_raw <- perform_request("countries/all", language, per_page)

  countries_processed <- tibble(
      id =  extract_values(countries_raw, "id"),
      iso2code =  extract_values(countries_raw, "iso2Code"),
      name =  extract_values(countries_raw, "name"),
      region_id =  extract_values(countries_raw, "region$id"),
      region_iso2code =  extract_values(countries_raw, "region$iso2code"),
      region_value =  extract_values(countries_raw, "region$value"),
      admin_region_id =  extract_values(countries_raw, "adminregion$id"),
      admin_region_iso2code =  extract_values(countries_raw, "adminregion$iso2code"),
      admin_region_value =  extract_values(countries_raw, "adminregion$value"),
      lending_type_id =  extract_values(countries_raw, "lendingType$id"),
      lending_type_iso2code =  extract_values(countries_raw, "lendingType$iso2code"),
      lending_type_value =  extract_values(countries_raw, "lendingType$value"),
      capital_city =  extract_values(countries_raw, "capitalCity"),
      longitude = extract_values(countries_raw, "longitude"),
      latitude =  extract_values(countries_raw, "latitude")
    ) |>
    mutate(across(where(is.character), ~ if_else(.x == "", NA, .x)))

  countries_processed
}
