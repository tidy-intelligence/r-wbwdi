test_that("perform_request validates per_page parameter", {
  expect_error(
    perform_request("countries", per_page = 0),
    "per_page"
  )

  expect_error(
    perform_request("countries", per_page = 40000),
    "per_page"
  )
})

test_that("perform_request validates max_tries parameter", {
  expect_error(
    perform_request("countries", max_tries = 0),
    "max_tries"
  )

  expect_error(
    perform_request("countries", max_tries = -1),
    "max_tries"
  )
})

test_that("perform_request constructs correct URL with all parameters", {
  skip_if_offline()

  result <- perform_request(
    resource = "countries",
    language = "en",
    per_page = 50,
    date = "2020:2021",
    source = 2
  )

  expect_type(result, "list")
})

test_that("perform_request handles single page response", {
  skip_if_offline()

  result <- perform_request(
    resource = "incomeLevels",
    per_page = 100
  )

  expect_type(result, "list")
  expect_true(length(result) > 0)
})

test_that("perform_request handles paginated responses", {
  skip_if_offline()

  result <- perform_request(
    resource = "countries",
    per_page = 10,
    progress = FALSE
  )

  expect_type(result, "list")
  expect_true(nrow(result) > 10)
})

test_that("perform_request works with progress bar enabled", {
  skip_if_offline()

  result <- perform_request(
    resource = "countries",
    per_page = 10,
    progress = TRUE
  )

  expect_type(result, "list")
})

test_that("perform_request handles language parameter", {
  skip_if_offline()

  result_en <- perform_request(
    resource = "countries",
    language = "en",
    per_page = 10
  )

  result_es <- perform_request(
    resource = "countries",
    language = "es",
    per_page = 10
  )

  expect_type(result_en, "list")
  expect_type(result_es, "list")
})

test_that("perform_request handles date parameter", {
  skip_if_offline()

  result <- perform_request(
    resource = "countries/USA/indicators/SP.POP.TOTL",
    date = "2015:2020",
    per_page = 100
  )

  expect_type(result, "list")
})

test_that("perform_request handles most_recent_only parameter", {
  skip_if_offline()

  result <- perform_request(
    resource = "countries/USA/indicators/SP.POP.TOTL",
    most_recent_only = 1,
    per_page = 100
  )

  expect_type(result, "list")
})

test_that("perform_request handles source parameter", {
  skip_if_offline()

  result <- perform_request(
    resource = "countries/USA/indicators/SP.POP.TOTL",
    source = 2,
    per_page = 100
  )

  expect_type(result, "list")
})

test_that("perform_request handles invalid resource gracefully", {
  skip_if_offline()

  expect_message(
    result <- perform_request(
      resource = "nonexistent_resource_xyz123",
      per_page = 10
    ),
    "Failed to retrieve data"
  )

  expect_null(result)
})

test_that("perform_request handles network errors gracefully", {
  expect_message(
    result <- perform_request(
      resource = "countries",
      base_url = "https://invalid.worldbank.org.invalid/v2/",
      max_tries = 2
    ),
    "Failed to retrieve data"
  )

  expect_null(result)
})

test_that("perform_request uses custom base_url", {
  skip_if_offline()

  result <- perform_request(
    resource = "countries",
    base_url = "https://api.worldbank.org/v2/",
    per_page = 10
  )

  expect_type(result, "list")
})

test_that("perform_request returns NULL on connection failure", {
  result <- perform_request(
    resource = "countries",
    base_url = "https://localhost:9999/",
    max_tries = 2
  )

  expect_null(result)
})

test_that("perform_request combines multiple pages correctly", {
  skip_if_offline()

  result_small <- perform_request(
    resource = "countries",
    per_page = 5
  )

  result_large <- perform_request(
    resource = "countries",
    per_page = 10000
  )

  expect_equal(length(result_small), length(result_large))
})

test_that("perform_request handles NULL optional parameters", {
  skip_if_offline()

  result <- perform_request(
    resource = "countries",
    language = NULL,
    date = NULL,
    most_recent_only = NULL,
    source = NULL
  )

  expect_type(result, "list")
})

test_that("perform_request max_tries parameter works", {
  start_time <- Sys.time()

  result <- perform_request(
    resource = "countries",
    base_url = "https://localhost:9999/",
    max_tries = 2
  )

  end_time <- Sys.time()

  expect_null(result)
  expect_true(as.numeric(end_time - start_time, units = "secs") < 10)
})

test_that("is_request_error identifies error responses correctly", {
  mock_resp <- structure(list(status_code = 404), class = "httr2_response")
  expect_true(is_request_error(mock_resp))
})

test_that("returns FALSE when body$message has length > 1", {
  dummy <- structure(list(), class = "resp")
  local_mocked_bindings(
    resp_status = function(resp) 200L,
    resp_body_json = function(resp) list(list(message = c("a", "b")))
  )
  expect_false(is_request_error(dummy))
})


test_that("perform_request handles API errors gracefully", {
  skip_if_offline()

  expect_message(perform_request("nonexistent"), "HTTP 404 Not Found.")
})
