#' Download World Bank indicator data for specific countries and multiple indicators
#'
#' This function retrieves indicator data from the World Bank API for a specified set of countries and indicators.
#' The user can specify one or more indicators, a date range, and other options to tailor the request. The data
#' is processed and returned in a tidy format, including country, indicator, date, and value fields.
#'
#' @param countries A character vector of ISO 2-country codes, or `"all"` to retrieve data for all countries.
#' @param indicators A character vector specifying one or more World Bank indicators to download (e.g., c("NY.GDP.PCAP.KD", "SP.POP.TOTL")).
#' @param start_date Optional. The starting date for the data, either as a year (e.g., `2010`) or a specific month (e.g., `"2012M01"`).
#' @param end_date Optional. The ending date for the data, either as a year (e.g., `2020`) or a specific month (e.g., `"2012M05"`).
#' @param language A character string specifying the language for the request, see \link{list_supported_languages}. Defaults to `"en"`.
#' @param per_page An integer specifying the number of results per page for the API. Defaults to 1000.
#' @param progress A logical value indicating whether to show progress messages during the data download and parsing. Defaults to `TRUE`.
#'
#' @return A tibble containing the indicator data for the specified countries and indicators. The following columns are included:
#' \describe{
#'   \item{indicator_id}{The ID of the indicator (e.g., "NY.GDP.PCAP.KD").}
#'   \item{country_id}{The ISO 2-country code of the country for which the data was retrieved.}
#'   \item{date}{The date of the indicator data (either a year or month depending on the request).}
#'   \item{value}{The value of the indicator for the given country and date.}
#' }
#'
#' @details This function constructs a request URL for the World Bank API, retrieves the relevant data for the given countries
#' and indicators, and processes the response into a tidy format. The user can optionally specify a date range, and the
#' function will handle requests for multiple pages if necessary. If the `progress` parameter is `TRUE`,
#' messages will be displayed during the request and parsing process.
#'
#' The function supports downloading multiple indicators by sending individual API requests for each indicator and then
#' combining the results into a single tidy data frame.
#'
#' @export
#'
#' @examples
#' # Download single indicator for multiple countries
#' download_indicators(c("US", "CA", "GB"), "NY.GDP.PCAP.KD")
#'
#' # Download single indicator for a specific time frame
#' download_indicators(c("US", "CA", "GB"), "DPANUSSPB", start_date = 2012, end_date = 2013)
#'
#' # Download single indicator for different frequency
#' download_indicators(c("MX", "CA", "US"), "DPANUSSPB", start_date = "2012M01", end_date = "2012M05")
#'
#' \donttest{
#' # Download single indicator for all countries and disable progress bar
#' download_indicators("all", "NY.GDP.PCAP.KD", progress = FALSE)
#'
#' # Download multiple indicators for multiple countries
#' download_indicators(c("US", "CA", "GB"), c("NY.GDP.PCAP.KD", "SP.POP.TOTL"))
#' }
download_indicators <- function(
  countries, indicators, start_date = NULL, end_date = NULL, language = "en", per_page = 1000, progress = TRUE
) {

  supported_languages <- list_supported_languages()
  if (!language %in% supported_languages$code) {
    supported_languages_str <- paste0(supported_languages$code, collapse = ", ")
    cli::cli_abort("{.arg language} must be one of: {supported_languages_str}.")
  }

  if (!is.numeric(per_page) || per_page %% 1 != 0 || per_page < 1 || per_page > 32500) {
    cli::cli_abort("{.arg per_page} must be an integer between 1 and 32,500.")
  }

  if (!is.logical(progress)) {
    cli::cli_abort("{.arg progress} must be either TRUE or FALSE.")
  }

  construct_request_indicator <- function(
    countries,
    indicator,
    start_date = NULL,
    end_date = NULL,
    language = "en",
    per_page = 1000
  ) {

    countries <- paste(countries, collapse = ";")

    if (!is.null(start_date) & !is.null(end_date)) {
      date <- paste0("&date=", start_date, ":", end_date)
    } else {
      date <- NULL
    }

    paste0(
      "https://api.worldbank.org/v2/",
      language, "/country/",
      countries, "/indicator/", indicator,
      "?format=json",
      date,
      "&per_page=", per_page
    )
  }

  indicators_processed <- list()

  for (j in 1:length(indicators)) {
    url <- construct_request_indicator(countries, indicators[j], start_date, end_date, language, per_page)

    response <- request(url) |>
      req_perform()

    body <- response |>
      resp_body_json()

    check_for_failed_request(body)

    pages <- body[[1]]$pages

    if (progress) {
      progress_req <- paste0("Sending requests for indicator ", indicators[j])
    } else {
      progress_req <- FALSE
    }

    if (pages > 1) {
      responses <- request(url) |>
        req_perform_iterative(next_req = iterate_with_offset("page"),
                              max_reqs = pages,
                              progress = progress_req)
    } else {
      responses <- list(response)
    }

    parse_response <- function(response) {
      body <- response |>
        resp_body_json()

      indicator_raw <- body[[2]]

      map_df(indicator_raw, function(x) {
        tibble(
          indicator_id = x$indicator$id,
          country_id = x$country$id,
          date = x$date,
          value = x$value
        )
      })
    }

    if (progress) {
      progress_parse <- paste0("Parsing responses for indicator ", indicators[j])
    } else {
      progress_parse <- FALSE
    }

    indicators_processed[[j]] <- map_df(responses, parse_response, .progress = progress_parse)
  }

  bind_rows(indicators_processed)

}
