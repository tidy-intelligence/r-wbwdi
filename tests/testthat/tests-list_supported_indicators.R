test_that("Invalid language input", {
  expect_error(
    list_supported_indicators(language = "xx")
  )
})

test_that("Invalid per_page input", {
  expect_error(
    list_supported_indicators(per_page = -1),
  )
  expect_error(
    list_supported_indicators(per_page = 50000)
  )
  expect_error(
    list_supported_indicators(per_page = "500")
  )
})

test_that("Invalid include_details input", {
  expect_error(
    list_supported_indicators(include_details = "yes")
  )
})

test_that("Invalid progress input", {
  expect_error(
    list_supported_indicators(progress = "yes")
  )
})

test_that("Valid output structure without details", {
  result <- list_supported_indicators(language = "en", per_page = 10, include_details = FALSE, progress = FALSE)
  expect_true(is.data.frame(result))
  expect_true(all(c("indicator_id", "indicator_name", "source_note", "source_organization") %in% names(result)))
})

test_that("Valid output structure with details", {
  result <- list_supported_indicators(language = "en", per_page = 10, include_details = TRUE, progress = FALSE)
  expect_true(is.data.frame(result))
  expect_true(all(c("indicator_id", "indicator_name", "unit", "source_id", "source_value", "source_note", "source_organization", "topics") %in% names(result)))
})
