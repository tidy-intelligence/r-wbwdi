test_that("Invalid language input", {
  expect_error(
    wdi_get_indicators(language = "xx")
  )
})

test_that("Invalid per_page input", {
  expect_error(
    wdi_get_indicators(per_page = -1),
  )
  expect_error(
    wdi_get_indicators(per_page = 50000)
  )
  expect_error(
    wdi_get_indicators(per_page = "500")
  )
})

test_that("Valid output structure", {
  result <- wdi_get_indicators(language = "en")
  expect_true(is.data.frame(result))
  expect_true(all(c("indicator_id", "indicator_name", "source_id", "source_name", "source_note", "source_organization", "topics") %in% names(result)))
})
