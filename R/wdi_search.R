#' Search for Keywords in Data Frame Columns
#'
#' This function searches for specified keywords across columns in a data frame
#' and returns only the rows where at least one keyword appears in any of the
#' specified columns. It supports nested columns (lists within columns) and
#' provides the option to limit the search to specific columns.
#'
#' @param data A data frame to search. It can include nested columns (lists
#'  within columns).
#' @param keywords A character vector of keywords to search for within the
#'  specified columns. The search is case-insensitive.
#' @param columns Optional. A character vector of column names to limit the
#'  search to specific columns. If `NULL`, all columns in `data` will be
#'  searched.
#'
#' @return A data frame containing only the rows where at least one keyword is
#'         found in the specified columns. The returned data frame has the same
#'         structure as `data`.
#'
#' @export
#'
#' @examplesIf curl::has_internet()
#' \donttest{
#' # Download indicators
#' indicators <- wdi_get_indicators()
#'
#' # Search for keywords "inequality" or "gender" across all columns
#' wdi_search(
#'   indicators,
#'   keywords = c("inequality", "gender")
#' )
#'
#' # Search for keywords only within the "indicator_name" column
#' wdi_search(
#'   indicators,
#'   keywords = c("inequality", "gender"),
#'   columns = c("indicator_name")
#' )
#'}
wdi_search <- function(data, keywords, columns = NULL) {

  if (is.null(columns)) {
    columns_to_search <- colnames(data)
  } else {
    columns_to_search <- intersect(columns, colnames(data))
  }

  row_matches <- purrr::map_lgl(seq_len(nrow(data)), function(i) {
    any(purrr::map_lgl(data[columns_to_search], ~ {
      col_value <- .x[[i]]
      if (is.list(col_value) && length(col_value) > 0) {
        any(purrr::map_lgl(unlist(col_value, recursive = TRUE, use.names = FALSE),
                           ~ contains_keyword(., keywords) %||% FALSE))
      } else if (!is.null(col_value) && length(col_value) > 0) {
        contains_keyword(col_value, keywords) %||% FALSE
      } else {
        FALSE
      }
    }))
  })

  data[row_matches, , drop = FALSE]
}

#' @keywords internal
#' @noRd
contains_keyword <- function(value, keywords) {
  value <- as.character(value)
  any(purrr::map_lgl(keywords, ~ grepl(.x, value, ignore.case = TRUE)))
}
