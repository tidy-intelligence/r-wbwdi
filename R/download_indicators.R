#' Download and process indicators data from the World Bank API
#'
#' This function retrieves a comprehensive list of indicators from the World Bank API.
#' The data is processed to extract and organize relevant fields such as the indicator's
#' ID, name, unit, source information, and associated topics. The function supports
#' optional progress messages during the parsing of indicators.
#'
#' @param progress A logical value indicating whether to show progress messages during the
#' parsing of indicators. Defaults to `TRUE`. If set to `FALSE`, no progress message is shown.
#'
#' @return A tibble containing processed indicator information. The following columns are included:
#' \describe{
#'   \item{indicator_id}{The ID of the indicator.}
#'   \item{indicator_name}{The name of the indicator.}
#'   \item{unit}{The unit of measurement for the indicator.}
#'   \item{source_id}{The ID of the source that provided the indicator.}
#'   \item{source_value}{The name of the source that provided the indicator.}
#'   \item{source_note}{Any additional notes from the source.}
#'   \item{source_organization}{The organization providing the source.}
#'   \item{topics}{A nested tibble containing the topics associated with the indicator, which includes topic_id and topic_value}
#' }
#'
#' @details The data is fetched in JSON format from the World Bank API and is processed
#' to handle missing or empty fields. Topics related to each indicator are nested in
#' a separate tibble within the main dataframe. If there are no topics for an indicator,
#' `NA` values are used.
#'
#' @export
#'
#' @examples
#' download_indicators()
#'
download_indicators <- function(
    progress = TRUE
) {

  if (!is.logical(progress)) {
    cli::cli_abort("The {.arg progress} must be either TRUE or FALSE.")
  }

  url <- "https://api.worldbank.org/v2/indicators?format=json&per_page=32500"

  responses <- request(url) |>
    req_perform()

  body <- responses |>
    resp_body_json()

  check_for_failed_request(body)

  indicators_raw <- body[[2]]

  if (progress) {
    progress <- "Parsing indicators:"
  }

  indicators_processed <- map_df(indicators_raw, function(x) {
    tibble(
      indicator_id = x$id,
      indicator_name = x$name,
      unit = x$unit %||% NA_character_,
      source_id = x$source$id,
      source_value = x$source$value,
      source_note = x$sourceNote,
      source_organization = x$sourceOrganization,
      topics = if (length(x$topics) > 0) {
        map_df(x$topics, ~ tibble(
          topic_id = .x$id %||% NA_character_,
          topic_value = .x$value %||% NA_character_
        ))
      } else {
        tibble(topic_id = NA_character_, topic_value = NA_character_)
      }
    )
  }, .progress = progress) |>
    tidyr::nest(topics = topics)

  indicators_processed
}
