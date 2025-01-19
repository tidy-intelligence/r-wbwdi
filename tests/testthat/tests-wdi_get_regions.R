test_that("wdi_get_regions handles invalid language input", {
  expect_error(
    wdi_get_regions(language = "xx")
  )
})

test_that("wdi_get_regions returns a tibble with correct column names", {
  skip_if_offline()

  result <- wdi_get_regions()
  expect_s3_class(result, "tbl_df")
  expected_colnames <- c(
    "region_id", "region_code", "region_iso2code", "region_name"
  )
  expect_true(all(expected_colnames %in% colnames(result)))
})

test_that("wdi_get_regions trims whitespace in character columns", {
  mock_data <- tibble(
    id = c(" 1 ", " 2 "),
    code = c(" EAS ", " ECS "),
    iso2code = c(" Z4 ", " Z7 "),
    name = c(" East Asia & Pacific ", " Europe & Central Asia ")
  )

  with_mocked_bindings(
    perform_request = function(...) mock_data,
    {
      result <- wdi_get_regions()
      expect_equal(result$region_id, c(1, 2))
      expect_equal(result$region_code, c("EAS", "ECS"))
      expect_equal(result$region_iso2code, c("Z4", "Z7"))
      expect_equal(result$region_name, c("East Asia & Pacific",
                                         "Europe & Central Asia"))
    }
  )
})

test_that("wdi_get_regions converts id to integer", {
  mock_data <- tibble(
    id = c("1", "2"),
    code = c("EAS", "ECS"),
    iso2code = c("Z4", "Z7"),
    name = c("East Asia & Pacific", "Europe & Central Asia")
  )

  with_mocked_bindings(
    perform_request = function(endpoint, language) mock_data,
    {
      result <- wdi_get_regions()
      expect_type(result$region_id, "integer")
      expect_equal(result$region_id, c(1L, 2L))
    }
  )
})

test_that("wdi_get_regions handles empty data gracefully", {
  mock_data <- tibble(
    id = character(),
    code = character(),
    iso2code = character(),
    name = character()
  )

  with_mocked_bindings(
    perform_request = function(...) mock_data,
    {
      result <- wdi_get_regions()
      expect_equal(nrow(result), 0)
    }
  )
})

test_that("wdi_get_regions handles different language inputs", {
  skip_if_offline()

  result <- wdi_get_regions(language = "fr")
  expected_columns <- c(
    "region_id", "region_code", "region_iso2code", "region_name"
  )
  expect_true(all(expected_columns %in% colnames(result)))
})
