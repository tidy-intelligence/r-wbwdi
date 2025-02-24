#' Download all available World Bank indicators
#'
#' This function retrieves a comprehensive list of all indicators supported by
#' the World Bank API. The indicators include metadata such as the indicator ID,
#' name, unit, source, and associated topics. The user can specify the language
#' of the API response and whether to include additional details.
#'
#' @param language A character string specifying the language for the request,
#'  see \link{wdi_get_languages}. Defaults to `"en"`.
#' @param per_page An integer specifying the number of results per page for the
#'  API. Defaults to 32,500. Must be a value between 1 and 32,500.
#'
#' @return A tibble containing the available indicators and their metadata:
#' \describe{
#'   \item{indicator_id}{A character string for the ID of the indicator (e.g.,
#'                       "NY.GDP.PCAP.KD").}
#'   \item{indicator_name}{A character string for the name of the indicator
#'                         (e.g., "GDP per capita, constant prices").}
#'   \item{source_id}{An integer identifying the data source providing the
#'                    indicator.}
#'   \item{source_name}{A character string describing the source of the
#'                      indicator data.}
#'   \item{source_note}{A character string providing additional notes about the
#'                      data source.}
#'   \item{source_organization}{A character string denoting the organization
#'                              responsible for the data source.}
#'   \item{topics}{A nested tibble containing (possibly multiple) topics
#'                 associated with the indicator, with two columns: an integer
#'                 \code{topic_id} and a character \code{topic_name}.}
#' }
#'
#' @details This function makes a request to the World Bank API to retrieve
#' metadata for all available indicators. It processes the response into a tidy
#' tibble format.
#'
#' @export
#'
#' @examplesIf curl::has_internet()
#' \donttest{
#' # Download all supported indicators in English
#' wdi_get_indicators()
#'
#' # Download all supported indicators in Spanish
#' wdi_get_indicators(language = "es")
#'}
#'
wdi_get_indicators <- function(language = "en", per_page = 32500L) {

  indicators_raw <- perform_request(
    "indicators", language = language, per_page = per_page
  )

  indicators_processed <- as_tibble(indicators_raw) |>
    rename(indicator_id = "id", indicator_name = "name") |>
    unnest_wider("source") |>
    rename(
      source_id = "id",
      source_name = "value",
      source_note = "sourceNote",
      source_organization = "sourceOrganization"
    ) |>
    select(-"unit") |>
    mutate(
      source_id = as.integer(.data$source_id),
      source_note = na_if(.data$source_note, ""),
      source_organization = na_if(.data$source_organization, "")
    )

  topics <- indicators_processed |>
    select("indicator_id", "topics") |>
    unnest_longer("topics") |>
    unnest_wider("topics") |>
    rename(topic_id = "id", topic_name = "value") |>
    mutate(
      topic_id = as.integer(.data$topic_id),
      topic_name = trimws(.data$topic_name)
    ) |>
    nest(topics = c("topic_id", "topic_name"))

  indicators_processed <- indicators_processed |>
    select(-"topics") |>
    left_join(topics, join_by("indicator_id"))

  indicators_processed
}
