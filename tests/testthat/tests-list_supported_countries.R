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
