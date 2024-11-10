test_that("wdi_get_handles invalid language input", {
  expect_error(
    wdi_get(
      geographies = "US", indicators = "NY.GDP.MKTP.CD", language = "xx"
    )
  )
})

test_that("wdi_get checks invalid parameter values", {
  expect_error(wdi_get("US", "NY.GDP.PCAP.KD", frequency = "weekly"),
               "must be either 'annual', 'quarter', or 'month'")
  expect_error(wdi_get("US", "NY.GDP.PCAP.KD", format = "tall"),
               "must be either 'long' or 'wide'")
})

test_that("wdi_get handles invalid per_page input", {
  expect_error(
    wdi_get(
      geographies = "US", indicators = "NY.GDP.MKTP.CD", per_page = -1
    )
  )
  expect_error(
    wdi_get(
      geographies = "US", indicators = "NY.GDP.MKTP.CD", per_page = "1000"
    )
  )
})

test_that("wdi_get handels invalid progress input", {
  expect_error(
    wdi_get(
      geographies = "US", indicators = "NY.GDP.MKTP.CD", progress = "yes"
    )
  )
})

test_that("wdi_get creates valid output structure for single indicator", {
  result <- wdi_get(
    geographies = "US",
    indicators = "NY.GDP.MKTP.CD",
    start_date = 2010, end_date = 2020,
    language = "en", per_page = 10, progress = FALSE
  )
  expected_names <- c("indicator_id", "geography_id", "year", "value")
  expect_true(is.data.frame(result))
  expect_true(all(expected_names %in% names(result)))
  expect_equal(nrow(result), 11)
})

test_that("wdi_get_creates valid output structure for multiple indicators", {
  result <- wdi_get(
    geographies = "US",
    indicators = c("NY.GDP.MKTP.CD", "SP.POP.TOTL"),
    start_date = 2010, end_date = 2020,
    language = "en", per_page = 10, progress = FALSE
  )
  expected_names <- c("indicator_id", "geography_id", "year", "value")
  expect_true(is.data.frame(result))
  expect_true(all(expected_names %in% names(result)))
  expect_true(any(result$indicator_id == "NY.GDP.MKTP.CD"))
  expect_true(any(result$indicator_id == "SP.POP.TOTL"))
})

test_that("wdi_get returns a tibble", {
  result <- wdi_get("US", "NY.GDP.PCAP.KD")
  expect_s3_class(result, "tbl_df")
})

test_that("wdi_get handles single indicator, geography & default parameters", {
  result <- wdi_get("US", "NY.GDP.PCAP.KD")
  expected_colnames <- c("indicator_id", "geography_id", "year", "value")
  expect_true(all(expected_colnames %in% colnames(result)))
  expect_equal(unique(result$geography_id), "US")
  expect_equal(unique(result$indicator_id), "NY.GDP.PCAP.KD")
})

test_that("wdi_get handles multiple indicators and multiple geographies", {
  result <- wdi_get(c("US", "CA"), c("NY.GDP.PCAP.KD", "SP.POP.TOTL"))
  expected_colnames <- c("indicator_id", "geography_id", "year", "value")
  expect_true(all(expected_colnames %in% colnames(result)))
  expect_true(all(result$geography_id %in% c("US", "CA")))
  expect_true(all(result$indicator_id %in% c("NY.GDP.PCAP.KD", "SP.POP.TOTL")))
})

test_that("wdi_get handles different date ranges and frequencies", {
  result_annual <- wdi_get(
    "US", "NY.GDP.PCAP.KD",
    start_date = 2010, end_date = 2015, frequency = "annual"
  )
  result_quarter <- wdi_get(
    "NG", "DT.DOD.DECT.CD.TL.US",
    start_date = 2010, end_date = 2015, frequency = "quarter"
  )
  result_month <- wdi_get(
    "US", "DPANUSSPB",
    start_date = 2010, end_date = 2015, frequency = "month"
  )

  expect_equal(range(result_annual$year), c(2010, 2015))
  expect_true("quarter" %in% colnames(result_quarter))
  expect_true("month" %in% colnames(result_month))
})

test_that("wdi_get handles format parameter (long and wide)", {
  result_long <- wdi_get("US", "NY.GDP.PCAP.KD", format = "long")
  result_wide <- wdi_get("US", "NY.GDP.PCAP.KD", format = "wide")

  expect_true("indicator_id" %in% colnames(result_long))
  expect_false("indicator_id" %in% colnames(result_wide))
})

test_that("wdi_get handles empty data gracefully", {

  mock_data <- data.frame(
    indicator = I(data.frame(
      id = character(),
      value = character()
    )),
    country = I(data.frame(
      id = character(),
      value = character()
    )),
    countryiso3code = character(),
    date = character(),
    value = numeric(),
    unit = character(),
    obs_status = character(),
    decimal = integer()
  )

  with_mocked_bindings(
    perform_request = function(...) mock_data,
    {
      result <- wdi_get("US", "NY.GDP.PCAP.KD")
      expect_equal(nrow(result), 0)
    }
  )
})

test_that("create_date constructs date range correctly", {
  expect_equal(create_date(2010, 2015), "2010:2015")
  expect_null(create_date(NULL, NULL))
})

test_that("validate_frequency checks valid frequencies", {
  expect_error(validate_frequency("weekly"),
               "must be either 'annual', 'quarter', or 'month'")
  expect_silent(validate_frequency("annual"))
  expect_silent(validate_frequency("quarter"))
  expect_silent(validate_frequency("month"))
})

test_that("validate_progress checks if progress is logical", {
  expect_error(validate_progress("yes"), "must be either TRUE or FALSE")
  expect_silent(validate_progress(TRUE))
  expect_silent(validate_progress(FALSE))
})

test_that("validate_source checks if source is valid", {
  with_mocked_bindings(
    wdi_get_sources = function(...) tibble(source_id = c(1, 2, 3)),
    {
      expect_error(validate_source(4), "is not supported")
      expect_silent(validate_source(1))
      expect_silent(validate_source(NULL))
    }
  )
})

test_that("validate_format checks valid formats", {
  expect_error(validate_format("tall"), "must be either 'long' or 'wide'")
  expect_silent(validate_format("long"))
  expect_silent(validate_format("wide"))
})
