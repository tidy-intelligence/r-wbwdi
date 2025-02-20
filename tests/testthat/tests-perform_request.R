test_that("perform_request handles error responses", {
  mock_error_response <- list(
    list(
      message = list(
        list(id = "120", value = "Invalid indicator")
      )
    )
  )

  with_mocked_bindings(
    create_request = function(...) NULL,
    req_retry = function(...) NULL,
    req_perform = function(...) mock_error_response,
    is_request_error = function(...) TRUE,
    handle_request_error = function(resp) stop("API error: Invalid indicator"),
    {
      expect_error(perform_request("indicators", language = "en"),
                   "API error: Invalid indicator")
    }
  )
})

test_that("perform_request validates per_page parameter", {
  skip_if_offline()

  expect_error(perform_request("countries", per_page = 50000))
  expect_silent(perform_request("countries", per_page = 1000))
})

test_that("perform_request validates max_tries parameter", {
  skip_if_offline()

  expect_error(perform_request("countries", max_tries = -100))
  expect_silent(perform_request("countries", max_tries = 2))
})

test_that("validate_per_page handles valid per_page values", {
  expect_error(validate_per_page(-1000))
  expect_silent(validate_per_page(1000))
  expect_silent(validate_per_page(1))
  expect_silent(validate_per_page(32500))
})

test_that("validate_per_page throws an error for invalid per_page values", {
  expect_error(validate_per_page(0),
               "must be an integer between 1 and 32,500")
  expect_error(validate_per_page(32501),
               "must be an integer between 1 and 32,500")
  expect_error(validate_per_page("1000"),
               "must be an integer between 1 and 32,500")
  expect_error(validate_per_page(1000.5),
               "must be an integer between 1 and 32,500")
})

test_that("validate_max_tries throws an error for invalid max_tries values", {
  expect_error(validate_max_tries(0),
               "must be an integer larger than 1")
  expect_error(validate_max_tries(-1),
               "must be an integer larger than 1")
  expect_error(validate_max_tries(1000.5),
               "must be an integer larger than 1")
})

test_that("create_request constructs a request with default parameters", {
  req <- create_request(
    "https://api.worldbank.org/v2", "incomeLevels",
    NULL, 1000, NULL, FALSE, NULL
  )
  expect_equal(
    req$url,
    "https://api.worldbank.org/v2/incomeLevels?format=json&per_page=1000"
  )
})

test_that("create_request constructs a request with parameters", {
  req <- create_request(
    "https://api.worldbank.org/v2", "lendingTypes",
    "en", 500, "2000:2020", FALSE, "2"
  )
  expect_equal(
    req$url,
    paste0("https://api.worldbank.org/v2/en/lendingTypes",
           "?format=json&per_page=500&date=2000%3A2020&source=2")
  )
})

test_that("is_request_error identifies error responses correctly", {
  mock_resp <- structure(list(status_code = 404), class = "httr2_response")
  expect_true(is_request_error(mock_resp))
})

test_that("perform_request handles API errors gracefully", {
  skip_if_offline()

  expect_error(perform_request("nonexistent"), "HTTP 404 Not Found.")
})
