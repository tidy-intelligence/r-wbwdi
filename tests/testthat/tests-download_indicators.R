test_that("Invalid language input", {
  expect_error(
    download_indicators(countries = "US", indicators = "NY.GDP.MKTP.CD", language = "xx")
  )
})

test_that("Invalid per_page input", {
  expect_error(
    download_indicators(countries = "US", indicators = "NY.GDP.MKTP.CD", per_page = -1)
  )
  expect_error(
    download_indicators(countries = "US", indicators = "NY.GDP.MKTP.CD", per_page = "1000")
  )
})

test_that("Invalid progress input", {
  expect_error(
    download_indicators(countries = "US", indicators = "NY.GDP.MKTP.CD", progress = "yes")
  )
})

test_that("Valid output structure for single indicator", {
  result <- download_indicators(countries = "US", indicators = "NY.GDP.MKTP.CD", start_date = 2010, end_date = 2020, language = "en", per_page = 10, progress = FALSE)
  expect_true(is.data.frame(result))
  expect_true(all(c("indicator_id", "country_id", "date", "value") %in% names(result)))
  expect_equal(nrow(result), 11)
})

test_that("Valid output structure for multiple indicators", {
  result <- download_indicators(countries = "US", indicators = c("NY.GDP.MKTP.CD", "SP.POP.TOTL"), start_date = 2010, end_date = 2020, language = "en", per_page = 10, progress = FALSE)
  expect_true(is.data.frame(result))
  expect_true(all(c("indicator_id", "country_id", "date", "value") %in% names(result)))
  expect_true(any(result$indicator_id == "NY.GDP.MKTP.CD"))
  expect_true(any(result$indicator_id == "SP.POP.TOTL"))
})
