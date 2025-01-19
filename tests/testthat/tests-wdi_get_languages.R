test_that("wdi_get_languages returns a tibble with correct column names", {
  skip_if_offline()

  result <- wdi_get_languages()
  expect_s3_class(result, "tbl_df")
  expected_columns <- c("language_code", "language_name", "native_form")
  expect_true(all(expected_columns %in% colnames(result)))
})

test_that("wdi_get_languages trims whitespace in character columns", {
  mock_data <- tibble(
    code = c(" en ", " es "),
    name = c(" English ", " Spanish "),
    nativeForm = c(" English ", " Español ")
  )

  with_mocked_bindings(
    perform_request = function(...) mock_data,
    {
      result <- wdi_get_languages()
      expect_equal(result$language_code, c("en", "es"))
      expect_equal(result$language_name, c("English", "Spanish"))
      expect_equal(result$native_form, c("English", "Español"))
    }
  )
})

test_that("wdi_get_languages handles empty data gracefully", {
  mock_data <- tibble(
    code = character(),
    name = character(),
    nativeForm = character()
  )

  with_mocked_bindings(
    perform_request = function(...) mock_data,
    {
      result <- wdi_get_languages()
      expect_equal(nrow(result), 0)
    }
  )
})
