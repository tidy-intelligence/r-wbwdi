#' Download World Bank indicator data for specific entities and time periods
#'
#' This function retrieves indicator data from the World Bank API for a
#' specified set of entities and indicators. The user can specify one or more
#' indicators, a date range, and other options to tailor the request. The data
#' is processed and returned in a tidy format, including country, indicator,
#' date, and value fields.
#'
#' @param entities A character vector of ISO 2 or ISO 3-country codes, or
#'  `"all"` to retrieve data for all entities.
#' @param indicators A character vector specifying one or more World Bank
#'  indicators to download (e.g., c("NY.GDP.PCAP.KD", "SP.POP.TOTL")).
#' @param start_year Optional integer. The starting date for the data as a year.
#' @param end_year Optional integer. The ending date for the data as a year.
#' @param most_recent_only A logical value indicating whether to download only
#'  the most recent value. In case of `TRUE`, it overrides `start_year` and
#'  `end_year`. Defaults to `FALSE`.
#' @param frequency A character string specifying the frequency of the data
#'  ("annual", "quarter", "month"). Defaults to "annual".
#' @param language A character string specifying the language for the request,
#'  see \link{wdi_get_languages}. Defaults to `"en"`.
#' @param per_page An integer specifying the number of results per page for the
#'  API. Defaults to 10,000.
#' @param progress A logical value indicating whether to show progress messages
#'  during the data download and parsing. Defaults to `TRUE`.
#' @param source An integer value specifying the data source, see
#'  \link{wdi_get_sources}.
#' @param format A character value specifying whether the data is returned in
#'  `"long"` or `"wide"` format. Defaults to `"long"`.
#'
#' @return A tibble with the following columns:
#' \describe{
#'   \item{entity_id}{The ISO 3-country code of the country or aggregate for
#'                    which the data was retrieved.}
#'   \item{indicator_id}{The ID of the indicator (e.g., "NY.GDP.PCAP.KD").}
#'   \item{year}{The year of the indicator data as an integer.}
#'   \item{quarter}{Optional. The quarter of the indicator data as integer.}
#'   \item{month}{Optional. The month of the indicator data as integer.}
#'   \item{value}{The value of the indicator for the given country and date.}
#' }
#'
#' @details This function constructs a request URL for the World Bank API,
#' retrieves the relevant data for the given entities and indicators, and
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
#' \donttest{
#' # Download single indicator for multiple entities
#' wdi_get(c("USA", "CAN", "GBR"), "NY.GDP.PCAP.KD")
#'
#' # Download single indicator for a specific time frame
#' wdi_get(c("USA", "CAN", "GBR"), "DPANUSSPB",
#'         start_year = 2012, end_year = 2013)
#'
#' # Download single indicator for monthly frequency
#' wdi_get("AUT", "DPANUSSPB",
#'         start_year = 2012, end_year = 2015, frequency = "month")
#'
#' # Download single indicator for quarterly frequency
#' wdi_get("NGA", "DT.DOD.DECT.CD.TL.US",
#'         start_year = 2012, end_year = 2015, frequency = "quarter")
#'
#' # Download single indicator for all entities and disable progress bar
#' wdi_get("all", "NY.GDP.PCAP.KD", progress = FALSE)
#'
#' # Download multiple indicators for multiple entities
#' wdi_get(c("USA", "CAN", "GBR"), c("NY.GDP.PCAP.KD", "SP.POP.TOTL"))
#'
#' # Download indicators for different sources
#' wdi_get("DEU", "SG.LAW.INDX", source = 2)
#' wdi_get("DEU", "SG.LAW.INDX", source = 14)
#'
#' # Download indicators in wide format
#' wdi_get(c("USA", "CAN", "GBR"), c("NY.GDP.PCAP.KD"),
#'         format = "wide")
#' wdi_get(c("USA", "CAN", "GBR"), c("NY.GDP.PCAP.KD", "SP.POP.TOTL"),
#'         format = "wide")
#'
#' # Download most recent value only
#' wdi_get("USA", "SP.POP.TOTL", most_recent_only = TRUE)
#' }
wdi_get <- function(
  entities,
  indicators,
  start_year = NULL,
  end_year = NULL,
  most_recent_only = FALSE,
  frequency = "annual",
  language = "en",
  per_page = 10000L,
  progress = TRUE,
  source = NULL,
  format = "long"
) {

  validate_most_recent_only(most_recent_only)
  validate_frequency(frequency)
  validate_progress(progress)
  validate_source(source)
  validate_format(format)

  if (!most_recent_only) {
    if (frequency == "annual") {
      start_year <- as.character(start_year)
      end_year <- as.character(end_year)
    }
    if (frequency == "quarter") {
      start_year <- paste0(start_year, "Q1")
      end_year <- paste0(end_year, "Q4")
    }
    if (frequency == "month") {
      start_year <- paste0(start_year, "M01")
      end_year <- paste0(end_year, "M12")
    }
  }

  indicators_processed <- indicators |>
    map_df(
      ~ get_indicator(
        ., entities, start_year, end_year, most_recent_only,
        language, per_page, progress, source
      )
    )

  if (format == "wide") {
    indicators_processed <- indicators_processed |>
      tidyr::pivot_wider(names_from = "indicator_id", values_from = "value")
  }

  # The ISO3 field is not always populated and sometimes the id already is ISO3
  if (nrow(indicators_processed) > 0 &&
        nchar(indicators_processed$entity_id[1]) == 2) {
    entities <- wdi_get_entities()

    indicators_processed <- indicators_processed |>
      rename(entity_iso2code = "entity_id") |>
      left_join(
        entities |>
          select("entity_id", "entity_iso2code"),
        join_by("entity_iso2code")
      ) |>
      select(-"entity_iso2code")
  }

  indicators_processed <- indicators_processed |>
    select("entity_id", everything())

  indicators_processed
}

#' @keywords internal
#' @noRd
validate_most_recent_only <- function(most_recent_only) {
  if (!is.logical(most_recent_only)) {
    cli::cli_abort("{.arg most_recent_only} must be either TRUE or FALSE.")
  }
}

#' @keywords internal
#' @noRd
validate_frequency <- function(frequency) {
  valid_frequencies <- c("annual", "quarter", "month")
  if (!frequency %in% valid_frequencies) {
    cli::cli_abort(
      "{.arg frequency} must be either 'annual', 'quarter', or 'month'."
    )
  }
}

#' @keywords internal
#' @noRd
validate_progress <- function(progress) {
  if (!is.logical(progress)) {
    cli::cli_abort("{.arg progress} must be either TRUE or FALSE.")
  }
}

#' @keywords internal
#' @noRd
validate_source <- function(source) {
  if (!is.null(source)) {
    supported_sources <- wdi_get_sources()
    if (!source %in% supported_sources$source_id) {
      cli::cli_abort(
        "{.arg source} is not supported. Please call {.fun wdi_get_sources()}."
      )
    }
  }
}

#' @keywords internal
#' @noRd
validate_format <- function(format) {
  if (!is.character(format) || !format %in% c("long", "wide")) {
    cli::cli_abort("{.arg format} must be either 'long' or 'wide'.")
  }
}

#' @keywords internal
#' @noRd
create_date <- function(start_year, end_year) {
  if (!is.null(start_year) && !is.null(end_year)) {
    paste0(start_year, ":", end_year)
  }
}

#' @keywords internal
#' @noRd
get_indicator <- function(
  indicator, entities, start_year, end_year, most_recent_only,
  language, per_page, progress, source
) {
  if (progress) {
    progress_req <- paste0("Sending requests for indicator ", indicator)
  } else {
    progress_req <- FALSE
  }

  date <- create_date(start_year, end_year)

  resource <- paste0(
    "country/", paste(entities, collapse = ";"),
    "/indicator/", indicator
  )

  indicator_raw <- perform_request(
    resource, language, per_page, date, most_recent_only, source, progress_req
  )

  indicator_parsed <- as_tibble(indicator_raw) |>
    rename(.value = "value") |>
    unnest_wider("indicator") |>
    rename(indicator_id = "id") |>
    select(-"value") |>
    unnest_wider("country") |>
    rename(entity_id = "id") |>
    select(-"value") |>
    select("indicator_id", "entity_id", "date", ".value") |>
    rename(value = ".value") |>
    mutate(value = as.numeric(.data$value))

  if (grepl("Q", indicator_parsed$date[1], fixed = TRUE)) {
    indicator <- indicator_parsed |>
      mutate(year = as.integer(substr(.data$date, 1, 4)),
             quarter = as.integer(substr(.data$date, 6, 6))) |>
      select(-"date") |>
      arrange(.data$year, .data$quarter)
  } else if (grepl("M", indicator_parsed$date[1], fixed = TRUE)) {
    indicator <- indicator_parsed |>
      mutate(year = as.integer(substr(.data$date, 1, 4)),
             month = as.integer(substr(.data$date, 6, 7))) |>
      select(-"date") |>
      arrange(.data$year, .data$month)
  } else {
    indicator <- indicator_parsed |>
      mutate(year = as.integer(.data$date)) |>
      select(-"date") |>
      arrange(.data$year)
  }

  indicator <- indicator |>
    relocate("value", .after = last_col())

  indicator
}
