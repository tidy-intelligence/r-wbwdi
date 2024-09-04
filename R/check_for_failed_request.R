#' Check for failed API request
#'
#' This function checks the response body from an API request to determine if the request failed.
#' If the request contains an error message, the function will raise an error with a detailed
#' message including the message ID and value.
#'
#' @param body The response body from the API request, typically in JSON format,
#' which may contain an error message if the request failed.
#'
#' @return This function does not return a value. If the request contains an error message,
#' it raises an error and halts execution.
#'
#' @details This function inspects the first element of the response body to check for
#' an error message. If a message is found, the function retrieves the `id`, `key`, and
#' `value` fields from the error message and constructs an error using `cli::cli_abort()`.
#' The function is intended to ensure failed API requests are handled gracefully.
#'
check_for_failed_request <- function(body) {
  if (!is.null(body[[1]]$message)) {

    message_id <- body[[1]]$message[[1]]$id
    message_key <- body[[1]]$message[[1]]$key
    message_value <- body[[1]]$message[[1]]$value

    cli::cli_abort(
      "Request failed with message ID {message_id}: {message_value}."
    )
  }
}
