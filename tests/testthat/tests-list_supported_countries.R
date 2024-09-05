test_that("Invalid language input", {
  expect_error(
    list_supported_countries(language = "xx")
  )
})

test_that("Invalid per_page input", {
  expect_error(
    list_supported_countries(per_page = -1),
  )
  expect_error(
    list_supported_countries(per_page = 50000)
  )
  expect_error(
    list_supported_countries(per_page = "500")
  )
})

test_that("Valid output structure", {
  result <- list_supported_countries(language = "en", per_page = 10)
  expect_true(is.data.frame(result))
  expect_true(all(c("iso2_code", "capital_city", "regions", "admin_regions", "income_levels", "lending_types") %in% names(result)))
})
