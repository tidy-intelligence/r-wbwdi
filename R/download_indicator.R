#' Download World Bank indicator data for specific countries
#'
#' This function retrieves indicator data from the World Bank API for a specified set of countries.
#' The user can specify an indicator, date range, and other options to tailor the request. The data
#' is processed and returned in a tidy format, including country, indicator, date, and value fields.
#'
#' @param countries A character vector of ISO 2-country codes, or `"all"` to retrieve data for all countries.
#' @param indicator A character string specifying the World Bank indicator to download (e.g., "NY.GDP.PCAP.KD").
#' @param start_date Optional. The starting date for the data, either as a year (e.g., `2010`) or a specific month (e.g., `"2012M01"`).
#' @param end_date Optional. The ending date for the data, either as a year (e.g., `2020`) or a specific month (e.g., `"2012M05"`).
#' @param language A character string specifying the language for the request. Defaults to `"en"`.
#' @param progress A logical value indicating whether to show progress messages during the data download and parsing. Defaults to `TRUE`.
#'
#' @return A tibble containing the indicator data for the specified countries. The following columns are included:
#' \describe{
#'   \item{indicator_id}{The ID of the indicator (e.g., "NY.GDP.PCAP.KD").}
#'   \item{country_id}{The ISO 2-country code of the country for which the data was retrieved.}
#'   \item{date}{The date of the indicator data (either a year or month depending on the request).}
#'   \item{value}{The value of the indicator for the given country and date.}
#' }
#'
#' @details This function constructs a request URL for the World Bank API, retrieves the relevant data,
#' and processes the response into a tidy format. The user can optionally specify a date range, and the
#' function will handle requests for multiple pages if necessary. If the `progress` parameter is `TRUE`,
#' messages will be displayed during the request and parsing process.
#'
#' @export
#'
#' @examples
#' download_indicator(c("MX", "CA", "US"), "NY.GDP.PCAP.KD")
#' download_indicator(c("MX", "CA", "US"), "DPANUSSPB", start_date = 2012, end_date = 2013)
#' download_indicator(c("MX", "CA", "US"), "DPANUSSPB", start_date = "2012M01", end_date = "2012M05")
#' download_indicator("all", "NY.GDP.PCAP.KD", progress = FALSE)
#'
download_indicator <- function(
  countries, indicator, start_date = NULL, end_date = NULL, language = "en", progress = TRUE
) {

  construct_request_indicator <- function(
    countries,
    indicator,
    start = NULL,
    end = NULL,
    language = "en",
    per_page = 1000
  ) {

    countries <- paste(countries, collapse = ";")

    if (!is.null(start) & !is.null(end)) {
      date <- paste0("&date=", start, ":", end)
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

  url <- construct_request_indicator(countries, indicator, start_date, end_date)

  response <- request(url) |>
    req_perform()

  body <- response |>
    resp_body_json()

  check_for_failed_request(body)

  pages <- body[[1]]$pages

  if (progress) {
    progress_req <- "Sending requests:"
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

    map_df(body[[2]], function(x) {
      tibble(
        indicator_id = x$indicator$id,
        country_id = x$country$id,
        date = x$date,
        value = x$value
      )
    })
  }

  if (progress) {
    progress_parse <- "Parsing responses:"
  } else {
    progress_parse <- FALSE
  }
  map_df(responses, parse_response, .progress = progress_parse)
}


