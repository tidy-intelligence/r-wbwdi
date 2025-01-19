test_that("wdi_get_sources handles invalid language input", {
  expect_error(
    wdi_get_sources(language = "xx")
  )
})

test_that("wdi_get_sources returns a tibble with correct column names", {
  skip_if_offline()

  result <- wdi_get_sources()
  expect_s3_class(result, "tbl_df")
  expected_colnames <- c(
    "source_id", "source_code", "source_name", "update_date",
    "is_data_available", "is_metadata_available", "concepts"
  )
  expect_true(all(expected_colnames %in% colnames(result)))
})

test_that("wdi_get_sources trims whitespace in character columns", {
  mock_data <- tibble(
    id = c(" 1 ", " 2 "),
    code = c(" WDI ", " GFDD "),
    name = c(" World Development Indicators ",
             " Global Financial Development "),
    lastupdated = c(" 2024-10-01 ", " 2024-11-01 "),
    dataavailability = c("Y", "N"),
    metadataavailability = c("Y", "Y"),
    concepts = c(" 100 ", " 200 ")
  )

  with_mocked_bindings(
    perform_request = function(...) mock_data,
    {
      result <- wdi_get_sources()
      expect_equal(result$source_id, c(1L, 2L))
      expect_equal(result$source_code, c("WDI", "GFDD"))
      expect_equal(result$source_name, c("World Development Indicators",
                                         "Global Financial Development"))
      expect_equal(result$update_date, as.Date(c("2024-10-01", "2024-11-01")))
      expect_equal(result$is_data_available, c(TRUE, FALSE))
      expect_equal(result$is_metadata_available, c(TRUE, TRUE))
      expect_equal(result$concepts, c(100L, 200L))
    }
  )
})

test_that("wdi_get_sources converts data types correctly", {
  mock_data <- tibble(
    id = c("1", "2"),
    code = c("WDI", "GFDD"),
    name = c("World Development Indicators", "Global Financial Development"),
    lastupdated = c("2024-10-01", "2024-11-01"),
    dataavailability = c("Y", "N"),
    metadataavailability = c("Y", "Y"),
    concepts = c("100", "200")
  )

  with_mocked_bindings(
    perform_request = function(...) mock_data,
    {
      result <- wdi_get_sources()
      expect_type(result$source_id, "integer")
      expect_type(result$update_date, "double")
      expect_type(result$is_data_available, "logical")
      expect_type(result$is_metadata_available, "logical")
      expect_type(result$concepts, "integer")
    }
  )
})

test_that("wdi_get_sources handles empty data gracefully", {
  mock_data <- tibble(
    id = character(),
    code = character(),
    name = character(),
    lastupdated = character(),
    dataavailability = character(),
    metadataavailability = character(),
    concepts = character()
  )

  with_mocked_bindings(
    perform_request = function(endpoint, language) mock_data,
    {
      result <- wdi_get_sources()
      expect_equal(nrow(result), 0)
    }
  )
})

test_that("wdi_get_sources handles different language inputs", {
  skip_if_offline()

  result <- wdi_get_sources(language = "es")
  expected_colnames <- c(
    "source_id", "source_code", "source_name", "update_date",
    "is_data_available", "is_metadata_available", "concepts"
  )
  expect_true(all(expected_colnames %in% colnames(result)))
})
