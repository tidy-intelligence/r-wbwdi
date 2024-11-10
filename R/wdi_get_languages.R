#' Download languages from the World Bank API
#'
#' This function returns a tibble of supported languages for querying the World
#' Bank API. The supported languages include English, Spanish, French, Arabic,
#' and Chinese, etc.
#'
#' @return A tibble with three columns:
#' \describe{
#'   \item{language_code}{A character string representing the language code
#'                        (e.g., "en" for English).}
#'   \item{language_name}{A character string representing the description of the
#'                        language (e.g., "English").}
#'   \item{native_form}{A character string representing the native form of the
#'                      language (e.g., "English").}
#' }
#'
#' @details This function provides a simple reference for the supported
#' languages when querying the World Bank API.
#'
#' @source https://api.worldbank.org/v2/languages
#'
#' @export
#'
#' @examplesIf curl::has_internet()
#' # Download all languages
#' wdi_get_languages()
#'
wdi_get_languages <- function() {

  # languages resource does not support multiple languages
  languages_raw <- perform_request("languages")

  languages_processed <- as_tibble(languages_raw) |>
    select(language_code = "code",
           language_name = "name",
           native_form = "nativeForm") |>
    mutate(across(where(is.character), trimws))

  languages_processed
}
