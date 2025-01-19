test_that("wdi_get_lending_types handles invalid language input", {
  expect_error(
    wdi_get_lending_types(language = "xx")
  )
})

test_that("wdi_get_lending_types returns a tibble with correct column names", {
  skip_if_offline()

  result <- wdi_get_lending_types()
  expect_s3_class(result, "tbl_df")
  expected_colnames <- c(
    "lending_type_id", "lending_type_iso2code", "lending_type_name"
  )
  expect_true(all(expected_colnames %in% colnames(result)))
})

test_that("wdi_get_lending_types trims whitespace in character columns", {
  mock_data <- tibble(
    id = c(" IBRD ", " IDA "),
    iso2code = c(" B ", " D "),
    value = c(" International Bank for Reconstruction and Development ",
              " International Development Association ")
  )

  with_mocked_bindings(
    perform_request = function(...) mock_data,
    {
      result <- wdi_get_lending_types()
      expect_equal(result$lending_type_id, c("IBRD", "IDA"))
      expect_equal(result$lending_type_iso2code, c("B", "D"))
      expect_equal(result$lending_type_name,
                   c("International Bank for Reconstruction and Development",
                     "International Development Association"))
    }
  )
})

test_that("wdi_get_lending_types handles empty data gracefully", {
  mock_data <- tibble(
    id = character(),
    iso2code = character(),
    value = character()
  )

  with_mocked_bindings(
    perform_request = function(...) mock_data,
    {
      result <- wdi_get_lending_types()
      expect_equal(nrow(result), 0)
    }
  )
})

test_that("wdi_get_lending_types handles different language inputs", {
  skip_if_offline()

  result <- wdi_get_lending_types(language = "es")
  expected_colnames <- c(
    "lending_type_id", "lending_type_iso2code", "lending_type_name"
  )
  expect_true(all(expected_colnames %in% colnames(result)))
})
