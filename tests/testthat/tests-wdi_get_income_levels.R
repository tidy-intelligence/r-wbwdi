test_that("wdi_get_income_levels returns a tibble with correct column names", {
  skip_if_offline()

  result <- wdi_get_income_levels()
  expect_s3_class(result, "tbl_df")
  expected_colnames <- c(
    "income_level_id", "income_level_iso2code", "income_level_name"
  )
  expect_true(all(expected_colnames %in% colnames(result)))
})

test_that("wdi_get_income_levels trims whitespace in character columns", {
  mock_data <- tibble(
    id = c(" LIC ", " HIC "),
    iso2code = c(" 1 ", " 2 "),
    value = c(" Low income ", " High income ")
  )

  with_mocked_bindings(
    perform_request = function(...) mock_data,
    {
      result <- wdi_get_income_levels()
      expect_equal(result$income_level_id, c("LIC", "HIC"))
      expect_equal(result$income_level_iso2code, c("1", "2"))
      expect_equal(result$income_level_name, c("Low income", "High income"))
    }
  )
})

test_that("wdi_get_income_levels handles different language inputs", {
  skip_if_offline()

  result <- wdi_get_income_levels(language = "es")
  expected_colnames <- c(
    "income_level_id", "income_level_iso2code", "income_level_name"
  )
  expect_true(all(expected_colnames %in% colnames(result)))
})

test_that("wdi_get_income_levels handles empty data gracefully", {
  mock_data <- tibble(
    id = character(),
    iso2code = character(),
    value = character()
  )

  with_mocked_bindings(
    perform_request = function(...) mock_data,
    {
      result <- wdi_get_income_levels()
      expect_equal(nrow(result), 0)
    }
  )
})
