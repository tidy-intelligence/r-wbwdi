test_that("wdi_get_indicators handles ivalid language input", {
  expect_error(
    wdi_get_indicators(language = "xx")
  )
})

test_that("wdi_get_indicators handles invalid per_page input", {
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

test_that("wdi_get_indicators returns a tibble with correct column names", {
  skip_if_offline()

  result <- wdi_get_indicators()
  expect_s3_class(result, "tbl_df")

  expected_colnames <- c(
    "indicator_id", "indicator_name", "source_id", "source_name",
    "source_note", "source_organization", "topics"
  )
  expect_true(all(expected_colnames %in% colnames(result)))
})

test_that("wdi_get_indicators handles type conversions and missing values", {
  mock_data <- tibble(
    id = "NY.GDP.PCAP.KD",
    name = "GDP per capita, constant prices",
    source = list(tibble(id = "2",
                         value = "World Development Indicators",
                         sourceNote = "Some note",
                         sourceOrganization = "World Bank")),
    unit = c(""),
    topics = list(list(list(id = "1", value = "Economy")))
  )

  with_mocked_bindings(
    perform_request = function(...) mock_data,
    {
      result <- wdi_get_indicators()
      expect_equal(result$indicator_id, "NY.GDP.PCAP.KD")
      expect_equal(result$indicator_name, "GDP per capita, constant prices")
      expect_equal(result$source_id, 2L)
      expect_equal(result$source_name, "World Development Indicators")
      expect_equal(result$source_note, "Some note")
      expect_equal(result$source_organization, "World Bank")
      expect_type(result$topics, "list")
      expect_equal(result$topics[[1]]$topic_id[1], 1L)
      expect_equal(result$topics[[1]]$topic_name[1], "Economy")
    }
  )
})

test_that("wdi_get_indicators handles different language inputs", {
  skip_if_offline()

  result <- wdi_get_indicators(language = "es")
  expected_colnames <- c(
    "indicator_id", "indicator_name", "source_id", "source_name",
    "source_note", "source_organization", "topics"
  )
  expect_true(all(expected_colnames %in% colnames(result)))
})
