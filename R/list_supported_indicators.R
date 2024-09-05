#' List all supported World Bank indicators
#'
#' This function retrieves a comprehensive list of all indicators supported by the World Bank API.
#' The indicators include metadata such as the indicator ID, name, unit, source, and associated topics.
#' The user can specify the language of the API response.
#'
#' @param language A character string specifying the language for the request. Supported values are:
#' \describe{
#'   \item{"en"}{English (default)}
#'   \item{"es"}{Spanish}
#'   \item{"fr"}{French}
#'   \item{"ar"}{Arabic}
#'   \item{"zh"}{Chinese}
#' }
#' @param per_page An integer specifying the number of results per page for the API. Defaults to 32500.
#' @param progress A logical value indicating whether to show progress messages during the data parsing process. Defaults to `TRUE`.
#'
#' @return A tibble containing the available indicators and their metadata. The tibble includes the following columns:
#' \describe{
#'   \item{indicator_id}{The ID of the indicator (e.g., "NY.GDP.PCAP.KD").}
#'   \item{indicator_name}{The name of the indicator (e.g., "GDP per capita, constant prices").}
#'   \item{unit}{The unit of measurement for the indicator, if available (e.g., "US Dollars").}
#'   \item{source_id}{The ID of the data source providing the indicator.}
#'   \item{source_value}{The name or description of the source of the indicator data.}
#'   \item{source_note}{Additional notes or descriptions about the data source.}
#'   \item{source_organization}{The organization responsible for the data source.}
#'   \item{topics}{A nested tibble containing topics associated with the indicator, with two columns: \code{topic_id} and \code{topic_value}.}
#' }
#'
#' @details This function makes a request to the World Bank API to retrieve metadata for all available indicators.
#' It processes the response into a tidy tibble format. If the `progress` parameter is `TRUE`, messages will be displayed
#' during the parsing process.
#'
#' @export
#'
#' @examples
#' \donttest{
#' # List all supported indicators in English
#' list_supported_indicators(language = "en")
#'
#' # List all supported indicators in Spanish
#' list_supported_indicators(language = "es")
#' }
list_supported_indicators <- function(language = "en", per_page = 32500, progress = TRUE) {

  supported_languages <- list_supported_languages()
  if (!language %in% supported_languages$code) {
    supported_languages_str <- paste0(supported_languages$code, collapse = ", ")
    cli::cli_abort("Unsupported language. Please choose one of: {supported_languages_str}")
  }

  url <- paste0("https://api.worldbank.org/v2/", language, "/indicators?format=json&per_page=", per_page)

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
