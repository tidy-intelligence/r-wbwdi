#' List all supported World Bank indicators
#'
#' This function retrieves a comprehensive list of all indicators supported by the World Bank API.
#' The indicators include metadata such as the indicator ID, name, unit, source, and associated topics.
#' The user can specify the language of the API response and whether to include additional details.
#'
#' @param language A character string specifying the language for the request, see \link{list_supported_languages}. Defaults to `"en"`.
#' @param per_page An integer specifying the number of results per page for the API. Defaults to 32,500.
#' Must be a value between 1 and 32,500.
#' @param include_details A logical value indicating whether to include additional details such as `unit` and `topics` in the result.
#' When `FALSE`, only basic information (ID, name, source) is returned. Defaults to `FALSE`.
#' @param progress A logical value indicating whether to show progress messages during the data parsing process. Defaults to `TRUE`.
#'
#' @return A tibble containing the available indicators and their metadata. Depending on the value of `include_details`,
#' the tibble includes the following columns:
#' \describe{
#'   \item{indicator_id}{The ID of the indicator (e.g., "NY.GDP.PCAP.KD").}
#'   \item{indicator_name}{The name of the indicator (e.g., "GDP per capita, constant prices").}
#'   \item{unit}{The unit of measurement for the indicator, if available (e.g., "US Dollars"). Included only if `include_details = TRUE`.}
#'   \item{source_id}{The ID of the data source providing the indicator. Included only if `include_details = TRUE`.}
#'   \item{source_value}{The name or description of the source of the indicator data. Included only if `include_details = TRUE`.}
#'   \item{source_note}{Additional notes or descriptions about the data source.}
#'   \item{source_organization}{The organization responsible for the data source.}
#'   \item{topics}{A nested tibble containing topics associated with the indicator, with two columns: \code{topic_id} and \code{topic_value}.
#'   Included only if `include_details = TRUE`.}
#' }
#'
#' @details This function makes a request to the World Bank API to retrieve metadata for all available indicators.
#' It processes the response into a tidy tibble format. If the `include_details` parameter is `FALSE`, the result
#' will only include basic indicator information (ID, name, source note, and organization). If `include_details` is `TRUE`,
#' additional metadata such as the indicator's unit, source ID and value, and associated topics will be included.
#'
#' If the `progress` parameter is set to `TRUE`, messages will be displayed during the request and parsing process.
#'
#' @export
#'
#' @examples
#' \donttest{
#' # List all supported indicators in English
#' list_supported_indicators(language = "en")
#'
#' # List all supported indicators in Spanish
#' list_supported_indicators(language = "es", include_details = TRUE)
#' }
list_supported_indicators <- function(language = "en", per_page = 32500, include_details = FALSE, progress = TRUE) {

  supported_languages <- list_supported_languages()
  if (!language %in% supported_languages$code) {
    supported_languages_str <- paste0(supported_languages$code, collapse = ", ")
    cli::cli_abort("{.arg language} must be one of: {supported_languages_str}.")
  }

  if (!is.numeric(per_page) || per_page %% 1 != 0 || per_page < 1 || per_page > 32500) {
    cli::cli_abort("{.arg per_page} must be an integer between 1 and 32,500.")
  }

  if (!is.logical(include_details)) {
    cli::cli_abort("{.arg include_details} must be either TRUE or FALSE.")
  }


  if (!is.logical(progress)) {
    cli::cli_abort("{.arg progress} must be either TRUE or FALSE.")
  }

  url <- paste0("https://api.worldbank.org/v2/", language, "/indicators?format=json&per_page=", per_page)

  responses <- request(url) |>
    req_perform()

  body <- responses |>
    resp_body_json()

  check_for_failed_request(body)

  indicators_raw <- body[[2]]

  if (!include_details) {
    indicators_raw <- purrr::map(indicators_raw, ~purrr::list_modify(.x, topics = NULL, unit = NULL))
    indicators_processed <- bind_rows(
      indicators_raw
    ) |>
      mutate(across(where(is.character), ~ if_else(.x == "", NA, .x))) |>
      select(indicator_id = id,
             indicator_name = name,
             source_note = sourceNote,
             source_organization = sourceOrganization)

  } else {

    if (progress) {
      progress <- "Parsing indicators:"
    }

    indicators_processed <- map_df(indicators_raw, function(x) {
      tibble(
        indicator_id = x$id,
        indicator_name = x$name,
        unit = if_else(is.null(x$unit), NA_character_, x$unit),
        source_id = x$source$id,
        source_value = x$source$value,
        source_note = x$sourceNote,
        source_organization = x$sourceOrganization,
        topics = if (length(x$topics) > 0) {
          map_df(x$topics, ~ tibble(
            topic_id = if_else(is.null(x$id), NA_character_, x$unit),
            topic_value = if_else(is.null(x$value), NA_character_, x$unit)
          ))
        } else {
          tibble(topic_id = NA_character_, topic_value = NA_character_)
        }
      )
    }, .progress = progress) |>
      mutate(across(where(is.character), ~ if_else(.x == "", NA, .x))) |>
      tidyr::nest(topics = topics)
  }

  indicators_processed
}
