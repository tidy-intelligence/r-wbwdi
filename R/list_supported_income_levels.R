#' List supported income levels for the World Bank API
#'
#' This function returns a tibble of supported income levels for querying the World Bank API.
#' The income levels categorize countries based on their gross national income per capita.
#'
#' @param language A character string specifying the language code for the API response (default is "en" for English).
#'
#' @return A tibble with columns that typically include:
#' \describe{
#'   \item{id}{The unique identifier for the income level.}
#'   \item{value}{The description of the income level (e.g., "Low income", "High income").}
#' }
#'
#' @details This function provides a reference for the supported income levels, which categorize countries
#' according to their income group as defined by the World Bank. The language parameter allows the results
#' to be returned in different languages as supported by the API.
#'
#' @source https://api.worldbank.org/v2/incomeLevels
#'
#' @export
#'
#' @examples
#' # List all supported income levels in English
#' list_supported_income_levels()
#'
list_supported_income_levels <- function(language = "en") {

  income_levels_raw <- perform_request("incomeLevels", language)

  income_levels_processed <- bind_rows(income_levels_raw)

  income_levels_processed
}
