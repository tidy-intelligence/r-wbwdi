#' List supported topics for the World Bank API
#'
#' This function returns a tibble of supported topics for querying the World Bank API.
#' Topics represent the broad subject areas covered by the World Bank's datasets.
#'
#' @param language A character string specifying the language code for the API response (default is "en" for English).
#'
#' @return A tibble with three columns:
#' \describe{
#'   \item{id}{The unique identifier for the topic.}
#'   \item{value}{The name of the topic (e.g., "Education", "Health").}
#'   \item{source_note}{A brief description or note about the topic.}
#' }
#'
#' @details This function provides a reference for the supported topics that can be used to refine
#' your queries when accessing the World Bank API. Topics represent different areas of focus for data analysis.
#'
#' @source https://api.worldbank.org/v2/topics
#'
#' @export
#'
#' @examples
#' # List all supported topics
#' list_supported_topics()
#'
list_supported_topics <- function(language = "en") {

  topics_raw <- perform_request("topics", language)

  topics_processed <- bind_rows(topics_raw) |>
    select(id, value, source_note = sourceNote) |>
    mutate(id = as.integer(id))

  topics_processed
}
