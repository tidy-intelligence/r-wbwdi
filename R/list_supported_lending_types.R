#' List supported lending types for the World Bank API
#'
#' This function returns a tibble of supported lending types for querying the World Bank API.
#' The lending types classify countries based on the financial terms available to them from the World Bank.
#'
#' @param language A character string specifying the language code for the API response (default is "en" for English).
#'
#' @return A tibble with columns that typically include:
#' \describe{
#'   \item{id}{The unique identifier for the lending type.}
#'   \item{value}{The description of the lending type (e.g., "IBRD", "IDA").}
#' }
#'
#' @details This function provides a reference for the supported lending types, which classify countries
#' according to the financial terms they are eligible for under World Bank programs. The language parameter
#' allows the results to be returned in different languages as supported by the API.
#'
#' @source https://api.worldbank.org/v2/lendingTypes
#'
#' @export
#'
#' @examples
#' # List all supported lending types in English
#' list_supported_lending_types()
#'
list_supported_lending_types <- function(language = "en") {

  lending_types_raw <- perform_request("lendingTypes", language)

  lending_types_processed <- bind_rows(lending_types_raw)

  lending_types_processed
}
