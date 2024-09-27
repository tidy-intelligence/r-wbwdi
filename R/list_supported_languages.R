#' List supported languages for the World Bank API
#'
#' This function returns a tibble of supported languages for querying the World Bank API.
#' The supported languages include English, Spanish, French, Arabic, and Chinese, etc.
#'
#' @return A tibble with three columns:
#' \describe{
#'   \item{code}{The ISO 639-1 code of the language (e.g., "en" for English).}
#'   \item{name}{The full name of the language (e.g., "English").}
#'   \item{native_form}{The native form of the language (e.g., "English").}
#' }
#'
#' @details This function provides a simple reference for the supported languages when querying
#' the World Bank API.
#'
#' @source https://api.worldbank.org/v2/languages
#'
#' @export
#'
#' @examples
#' # List all supported languages
#' list_supported_languages()
#'
list_supported_languages <- function() {

  # languages resource does not support multiple languages
  response <- perform_request("languages")

  body <- response |>
    resp_body_json()

  languages <- bind_rows(body[[2]]) |>
    select(code, name, native_form = nativeForm) |>
    tidyr::drop_na()

  languages
}
