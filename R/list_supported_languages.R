#' List supported languages for the World Bank API
#'
#' This function returns a tibble of supported languages for querying the World Bank API.
#' The supported languages include English, Spanish, French, Arabic, and Chinese.
#'
#' @return A tibble with two columns:
#' \describe{
#'   \item{language_code}{The ISO 639-1 code of the language (e.g., "en" for English).}
#'   \item{language_name}{The full name of the language (e.g., "English").}
#' }
#'
#' @details This function provides a simple reference for the supported languages when querying
#' the World Bank API.
#'
#' @export
#'
#' @examples
#' # List all supported languages
#' list_supported_languages()
#'
list_supported_languages <- function() {
  tibble(
    code = c("en", "es", "fr", "ar", "zh"),
    name = c("English", "Spanish", "French", "Arabic", "Chinese")
  )
}
