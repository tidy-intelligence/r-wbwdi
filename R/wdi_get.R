#' Download World Bank indicator data for specific geographies and time periods
#'
#' This function retrieves indicator data from the World Bank API for a
#' specified set of geographies and indicators. The user can specify one or more
#' indicators, a date range, and other options to tailor the request. The data
#' is processed and returned in a tidy format, including country, indicator,
#' date, and value fields.
#'
#' @param geographies A character vector of ISO 2-country codes, or `"all"` to
#'  retrieve data for all geographies.
#' @param indicators A character vector specifying one or more World Bank
#'  indicators to download (e.g., c("NY.GDP.PCAP.KD", "SP.POP.TOTL")).
#' @param start_date Optional. The starting date for the data, either as a year
#'  (e.g., `2010`) or a specific month (e.g., `"2012M01"`).
#' @param end_date Optional. The ending date for the data, either as a year
#'  (e.g., `2020`) or a specific month (e.g., `"2012M05"`).
#' @param language A character string specifying the language for the request,
#'  see \link{wdi_get_languages}. Defaults to `"en"`.
#' @param per_page An integer specifying the number of results per page for the
#'  API. Defaults to 1000.
#' @param progress A logical value indicating whether to show progress messages
#'  during the data download and parsing. Defaults to `TRUE`.
#' @param source An integer value specifying the data source, see
#'  \link{wdi_get_sources}.
#' @param format A character value specifying whether the data is returned in
#'  `"long"` or `"wide"` format. Defaults to `"long"`.
#'
#' @return A tibble with the following columns:
#' \describe{
#'   \item{indicator_id}{The ID of the indicator (e.g., "NY.GDP.PCAP.KD").}
#'   \item{geography_id}{The ISO 2-country code of the country for which the
#'                       data was retrieved.}
#'   \item{date}{The date of the indicator data (either a year or month
#'               depending on the request).}
#'   \item{value}{The value of the indicator for the given country and date.}
#' }
#'
#' @details This function constructs a request URL for the World Bank API,
#' retrieves the relevant data for the given geographies and indicators, and
#' processes the response into a tidy format. The user can optionally specify a
#' date range, and the function will handle requests for multiple pages if
#' necessary. If the `progress` parameter is `TRUE`, messages will be displayed
#' during the request and parsing process.
#'
#' The function supports downloading multiple indicators by sending individual
#' API requests for each indicator and then combining the results into a single
#' tidy data frame.
#'
#' @export
#'
#' @examplesIf curl::has_internet()
#' # Download single indicator for multiple geographies
#' wdi_get(c("US", "CA", "GB"), "NY.GDP.PCAP.KD")
#'
#' # Download single indicator for a specific time frame
#' wdi_get(c("US", "CA", "GB"), "DPANUSSPB",
#'         start_date = 2012, end_date = 2013)
#'
#' # Download single indicator for different frequency
#' wdi_get(c("MX", "CA", "US"), "DPANUSSPB",
#'         start_date = "2012M01", end_date = "2012M05")
#'
#' \donttest{
#' # Download single indicator for all geographies and disable progress bar
#' wdi_get("all", "NY.GDP.PCAP.KD", progress = FALSE)
#'
#' # Download multiple indicators for multiple geographies
#' wdi_get(c("US", "CA", "GB"), c("NY.GDP.PCAP.KD", "SP.POP.TOTL"))
#' }
#'
#' # Download indicators for different sources
#' wdi_get("DE", "SG.LAW.INDX", source = 2)
#'
#' wdi_get("DE", "SG.LAW.INDX", source = 14)
#'
#' # Download indicators in wide format
#' wdi_get(c("US", "CA", "GB"), c("NY.GDP.PCAP.KD"),
#'         format = "wide")
#' wdi_get(c("US", "CA", "GB"), c("NY.GDP.PCAP.KD", "SP.POP.TOTL"),
#'         format = "wide")
#'
wdi_get <- function(
  geographies,
  indicators,
  start_date = NULL,
  end_date = NULL,
  language = "en",
  per_page = 1000,
  progress = TRUE,
  source = NULL,
  format = "long"
) {

  validate_progress(progress)
  validate_source(source)
  validate_format(format)

  indicators_processed <- indicators |>
    map_df(
      ~ get_indicator(
        ., geographies, start_date, end_date,
        language, per_page, progress, source
      )
    )

  if (format == "wide") {
    indicators_processed <- indicators_processed |>
      tidyr::pivot_wider(names_from = "indicator_id", values_from = "value")
  }

  indicators_processed
}

validate_progress <- function(progress) {
  if (!is.logical(progress)) {
    cli::cli_abort("{.arg progress} must be either TRUE or FALSE.")
  }
}

validate_source <- function(source) {
  if (!is.null(source)) {
    supported_sources <- wdi_get_sources()
    if (!source %in% supported_sources$source_id) {
      cli::cli_abort(
        "{.arg source} is not supported. Please call {.fun wdi_get_sources}."
      )
    }
  }
}

validate_format <- function(format) {
  if (!is.character(format) || !format %in% c("long", "wide")) {
    cli::cli_abort("{.arg format} must be either 'long' or 'wide'.")
  }
}

create_date <- function(start_date, end_date) {
  if (!is.null(start_date) && !is.null(end_date)) {
    paste0(start_date, ":", end_date)
  }
}

get_indicator <- function(
  indicator, geographies, start_date, end_date,
  language, per_page, progress, source
) {
  if (progress) {
    progress_req <- paste0("Sending requests for indicator ", indicator)
  } else {
    progress_req <- FALSE
  }

  date <- create_date(start_date, end_date)

  resource <- paste0(
    "country/", paste(geographies, collapse = ";"),
    "/indicator/", indicator
  )
  indicator_raw <- perform_request(
    resource, language, per_page, date, source, progress_req
  )

  parse_response <- function(x) {
    tibble(
      indicator_id = extract_values(x, "indicator$id"),
      geography_id = extract_values(x, "country$id"),
      date = extract_values(x, "date"),
      value = extract_values(x, "value", "numeric")
    )
  }

  parse_response(indicator_raw)
}
