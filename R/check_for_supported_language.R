#' Internal function to validate supported languages
#'
#' This function checks if the provided language is supported by the World Bank API.
#' If the language is not supported, it throws an error listing the available languages.
#'
#' @param language A character string specifying the language code to be validated.
#'
#' @return This function does not return a value. It either silently passes or throws an error if the language is unsupported.
#'
#' @details This is an internal helper function that checks the language against the list of supported languages
#' from the World Bank API. If the language is not supported, it throws an error using the `cli_abort()` function.
#'
#' @keywords internal
#'
#' @seealso [list_supported_languages()] for obtaining the list of supported languages.
#'
check_for_supported_language <- function(language) {
  supported_languages <- list_supported_languages()
  if (!language %in% supported_languages$code) {
    supported_languages <- paste0(supported_languages$code, collapse = ", ")
    cli::cli_abort("Unsupported language. Please choose one of: {supported_languages}")
  }
}
