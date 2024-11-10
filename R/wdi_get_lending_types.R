#' Download lending types from the World Bank API
#'
#' This function returns a tibble of supported lending types for querying the
#' World Bank API. The lending types classify countries based on the financial
#' terms available to them from the World Bank.
#'
#' @param language A character string specifying the language code for the API
#'  response (default is "en" for English).
#'
#' @return A tibble with columns that typically include:
#' \describe{
#'   \item{lending_type_id}{An integer for the lending type.}
#'   \item{lending_type_iso2code}{A character string for the ISO2 code of the
#'                                lending type.}
#'   \item{lending_type_name}{A description of the lending type (e.g., "IBRD",
#'                            "IDA").}
#' }
#'
#' @details This function provides a reference for the supported lending types,
#' which classify countries according to the financial terms they are eligible
#' for under World Bank programs. The language parameter allows the results to
#' be returned in different languages as supported by the API.
#'
#' @source https://api.worldbank.org/v2/lendingTypes
#'
#' @export
#'
#' @examplesIf curl::has_internet()
#' # Download all lending types in English
#' wdi_get_lending_types()
#'
wdi_get_lending_types <- function(language = "en") {

  lending_types_raw <- perform_request("lendingTypes", language)

  lending_types_processed <- as_tibble(lending_types_raw) |>
    select(
      lending_type_id = "id",
      lending_type_iso2code = "iso2code",
      lending_type_name = "value"
    ) |>
    mutate(across(where(is.character), trimws))

  lending_types_processed
}
