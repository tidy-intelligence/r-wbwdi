#' Internal function to perform API requests to the World Bank API
#'
#' This function constructs and sends a request to the specified World Bank API resource,
#' with the option to specify the language of the response.
#'
#' @param resource A character string specifying the resource endpoint for the World Bank API (e.g., "incomeLevels", "lendingTypes").
#' @param language A character string specifying the language code for the API response (default is "en" for English).
#' @param per_page An integer specifying the number of results per page for the API. Defaults to 1000.
#' Must be a value between 1 and 32,500.
#' @param base_url A character string specifying the base URL of the World Bank API (default is "https://api.worldbank.org/v2").
#'
#' @return The raw response object from the API request.
#'
#' @details This is an internal helper function used by other functions to interact with the World Bank API.
#' It constructs the request URL using the base URL, language, and resource, and then performs the request.
#'
#' @keywords internal
#'
perform_request <- function(resource, language = NULL, per_page = 1000, base_url = "https://api.worldbank.org/v2/") {

  if (!is.numeric(per_page) || per_page %% 1 != 0 || per_page < 1 || per_page > 32500) {
    cli::cli_abort("{.arg per_page} must be an integer between 1 and 32,500.")
  }

  if (!is.null(language)) {
    language <- paste0(language, "/")
  } else {
    language <- ""
  }
  url <- paste0(base_url, language, resource, "?format=json&per_page=", per_page)
  response <- request(url) |>
    req_perform()

  response
}
