test_that("Invalid language input", {
  expect_error(
    wdi_get_geographies(language = "xx")
  )
})

test_that("Invalid per_page input", {
  expect_error(
    wdi_get_geographies(per_page = -1),
  )
  expect_error(
    wdi_get_geographies(per_page = 50000)
  )
  expect_error(
    wdi_get_geographies(per_page = "500")
  )
})
