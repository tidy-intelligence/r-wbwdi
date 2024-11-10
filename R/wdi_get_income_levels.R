#' Download income levels from the World Bank API
#'
#' This function returns a tibble of supported income levels for querying the
#' World Bank API. The income levels categorize countries based on their gross
#' national income per capita.
#'
#' @param language A character string specifying the language code for the API
#'  response (default is "en" for English).
#'
#' @return A tibble with columns that typically include:
#' \describe{
#'   \item{income_level_id}{An integer identifier for the income level.}
#'   \item{income_level_iso2code}{A character string representing the ISO2 code
#'                                for the income level.}
#'   \item{income_level_name}{The description of the income level (e.g.,
#'                            "Low income", "High income").}
#' }
#'
#' @details This function provides a reference for the supported income levels,
#' which categorize countries according to their income group as defined by the
#' World Bank. The language parameter allows the results to be returned in
#' different languages as supported by the API.
#'
#' @source https://api.worldbank.org/v2/incomeLevels
#'
#' @export
#'
#' @examplesIf curl::has_internet()
#' # Download all income levels in English
#' wdi_get_income_levels()
#'
wdi_get_income_levels <- function(language = "en") {

  income_levels_raw <- perform_request("incomeLevels", language)

  income_levels_processed <- as_tibble(income_levels_raw) |>
    rename(
      income_level_id = "id",
      income_level_iso2code = "iso2code",
      income_level_name = "value"
    ) |>
    mutate(across(where(is.character), trimws))

  income_levels_processed
}
