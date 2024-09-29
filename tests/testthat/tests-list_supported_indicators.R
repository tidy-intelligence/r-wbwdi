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

test_that("Valid output structure", {
  result <- list_supported_indicators(language = "en")
  expect_true(is.data.frame(result))
  expect_true(all(c("id", "name", "source_id", "source_value", "source_note", "source_organization", "topics") %in% names(result)))
})
