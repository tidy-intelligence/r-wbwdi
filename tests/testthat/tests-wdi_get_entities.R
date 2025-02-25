test_that("wdi_get_entities handles invalid language input", {
  expect_error(
    wdi_get_entities(language = "xx")
  )
})

test_that("wdi_get_entities handles invalid per_page input", {
  expect_error(
    wdi_get_entities(per_page = -1),
  )
  expect_error(
    wdi_get_entities(per_page = 50000)
  )
  expect_error(
    wdi_get_entities(per_page = "500")
  )
})

test_that("wdi_get_entities returns a tibble with correct column names", {
  skip_if_offline()

  result <- wdi_get_entities()
  expect_s3_class(result, "tbl_df")
  expected_colnames <- c(
    "entity_id", "entity_name", "entity_iso2code", "entity_type",
    "region_id", "region_name", "region_iso2code", "admin_region_id",
    "admin_region_name", "admin_region_iso2code", "income_level_id",
    "income_level_name", "income_level_iso2code", "lending_type_id",
    "lending_type_name", "lending_type_iso2code", "capital_city",
    "longitude", "latitude"
  )
  expect_true(all(expected_colnames %in% colnames(result)))
})

test_that("wdi_get_entities handles type conversions and missing values", {
  mock_data <- tibble(
    id = "ABW",
    iso2Code = "AW",
    name = "Aruba",
    region = list(tibble(id = "LCN",
                         iso2code = "ZJ",
                         value = "Latin America & Caribbean")),
    adminregion = list(tibble(id = NA_character_,
                              iso2code = NA_character_,
                              value = NA_character_)),
    incomeLevel = list(tibble(id = "HIC",
                              iso2code = "XD",
                              value = "High income")),
    lendingType = list(tibble(id = "IBD",
                              iso2code = "XF",
                              value = "IBRD")),
    capitalCity = "Oranjestad",
    longitude = "70.0167",
    latitude = "12.5167"
  )

  with_mocked_bindings(
    perform_request = function(...) mock_data,
    {
      result <- wdi_get_entities()
      expect_equal(result$entity_id, "ABW")
      expect_equal(result$entity_iso2code, "AW")
      expect_equal(result$entity_name, "Aruba")
      expect_equal(result$region_id, "LCN")
      expect_equal(result$region_name, "Latin America & Caribbean")
      expect_equal(result$income_level_id, "HIC")
      expect_equal(result$lending_type_name, "IBRD")
      expect_equal(result$capital_city, "Oranjestad")
      expect_equal(result$longitude, 70.0167)
      expect_equal(result$latitude, 12.5167)
      expect_true(all(c("longitude", "latitude") %in% colnames(result)))
    }
  )
})

test_that("wdi_get_entities handles different language inputs", {
  skip_if_offline()

  result <- wdi_get_entities(language = "fr")

  expected_colnames <- c(
    "entity_id", "entity_name", "entity_iso2code", "entity_type",
    "region_id", "region_name", "region_iso2code", "admin_region_id",
    "admin_region_name", "admin_region_iso2code", "income_level_id",
    "income_level_name", "income_level_iso2code", "lending_type_id",
    "lending_type_name", "lending_type_iso2code", "capital_city",
    "longitude", "latitude"
  )
  expect_true(all(expected_colnames %in% colnames(result)))
})
