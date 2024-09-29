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
#' @param source An integer value specifying the data source, see \link{list_supported_sources}.
#' @param format A character value specifying whether the data is returned in `"long"` or `"wide"` format. Defaults to `"long"`.
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
#'
#' # Download indicators for different sources
#' download_indicators("DE", "SG.LAW.INDX", source = 2)
#' download_indicators("DE", "SG.LAW.INDX", source = 14)
#'
#' # Download indicators in wide format
#' download_indicators(c("US", "CA", "GB"), c("NY.GDP.PCAP.KD"), format = "wide")
#' download_indicators(c("US", "CA", "GB"), c("NY.GDP.PCAP.KD", "SP.POP.TOTL"), format = "wide")
#'
download_indicators <- function(
  countries,
  indicators,
  start_date = NULL,
  end_date = NULL,
  language = "en",
  per_page = 1000,
  progress = TRUE,
  source = NULL,
  format = "long"
) {

  if (!is.logical(progress)) {
    cli::cli_abort("{.arg progress} must be either TRUE or FALSE.")
  }

  if (!is.null(source)) {
    supported_sources <- list_supported_sources()
    if (!source %in% supported_sources$id) {
      cli::cli_abort("{.arg source} is not supported. Please call {.fun list_supported_sources}.")
    }
  }

  if (!is.character(format) || !format %in% c("long", "wide")) {
    cli::cli_abort("{.arg format} must be either 'long' or 'wide'.")
  }

  date <- if (!is.null(start_date) & !is.null(end_date)) {
    paste0(start_date, ":", end_date)
  } else {
    NULL
  }

  indicators_processed <- list()

  for (j in 1:length(indicators)) {

    if (progress) {
      progress_req <- paste0("Sending requests for indicator ", indicators[j])
    } else {
      progress_req <- FALSE
    }

    resource <- paste0("country/", paste(countries, collapse = ";"), "/indicator/", indicators[j])
    indicators_raw <- perform_request(resource, language, per_page, date, source, progress_req)

    parse_response <- function(x) {
      tibble(
        indicator_id = extract_values(x, "indicator$id"),
        country_id = extract_values(x, "country$id"),
        date = extract_values(x, "date"),
        value = extract_values(x, "value", "numeric")
      )
    }

    indicators_processed[[j]] <- parse_response(indicators_raw)
  }

  indicators_processed <- bind_rows(indicators_processed)

  if (format == "wide") {
    indicators_processed <- indicators_processed |>
      tidyr::pivot_wider(names_from = indicator_id, values_from = value)
  }

  indicators_processed
}
