#' Extract values from a list of data using a specified path expression.
#'
#' This function evaluates a path expression within each element of a list of data and extracts the corresponding values.
#' It utilizes tidy evaluation to dynamically compute the result based on the provided path.
#'
#' @param data A list of data, where each element is typically a named list or data frame.
#' @param path A string representing the path expression to extract values from each element of `data`.
#'
#' @return A character vector of extracted values, corresponding to the evaluated path expression in each element of `data`.
#' If a value is not found or the path cannot be evaluated for an element, the result will be `NA_character_`.
#'
#' @keywords internal
#'
extract_values <- function(data, path) {
  path_expr <- rlang::parse_expr(path)
  vapply(data, function(x) rlang::eval_tidy(path_expr, x), FUN.VALUE = NA_character_, USE.NAMES = FALSE)
}
