#' List all supported countries and regions from the World Bank API
#'
#' This function retrieves and processes a list of all countries supported by the World Bank API,
#' along with metadata such as region, administrative region, income level, and lending type.
#' The user can specify the language of the API response.
#'
#' @param language A character string specifying the language for the request, see \link{list_supported_languages}. Defaults to `"en"`.
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
#' # List all supported countries in English
#' list_supported_countries(language = "en")
#'
#' # List all supported countries in Spanish
#' list_supported_countries(language = "zh")
#'
list_supported_countries <- function(language = "en", per_page = 1000) {

  supported_languages <- list_supported_languages()
  if (!language %in% supported_languages$code) {
    supported_languages <- paste0(supported_languages$code, collapse = ", ")
    cli::cli_abort("Unsupported language. Please choose one of: {supported_languages}")
  }

  if (!is.numeric(per_page) || per_page %% 1 != 0 || per_page < 1 || per_page > 32500) {
    cli::cli_abort("{.arg per_page} must be an integer between 1 and 32,500.")
  }

  url <- paste0("https://api.worldbank.org/v2/", language, "/countries/all?per_page=", per_page, "&format=json")

  responses <- request(url) |>
    req_perform()

  body <- responses |>
    resp_body_json()

  check_for_failed_request(body)

  countries_raw <- body[[2]] |>
    bind_rows()

  countries_processed <- countries_raw|>
    tidyr::unnest(c(region, adminregion, incomeLevel, lendingType)) |>
    mutate(across(where(is.character), ~ if_else(.x == "", NA, .x))) |>
    rename(iso2_code = iso2Code,
           admin_region = adminregion,
           income_level = incomeLevel,
           lending_type = lendingType,
           capital_city = capitalCity) |>
    tidyr::nest(regions = region,
                admin_regions = admin_region,
                income_levels = income_level,
                lending_types = lending_type)

  countries_processed
}
