test_that("wdi_get_topics handles invalid language input", {
  expect_error(
    wdi_get_topics(language = "xx")
  )
})

test_that("wdi_get_topics returns a tibble with correct column names", {
  skip_if_offline()

  result <- wdi_get_topics()
  expect_s3_class(result, "tbl_df")
  expected_colnames <- c("topic_id", "topic_name", "topic_note")
  expect_true(all(expected_colnames %in% colnames(result)))
})

test_that("wdi_get_topics trims whitespace in character columns", {
  mock_data <- tibble(
    id = c(" 1 ", " 2 "),
    value = c(" Education ", " Health "),
    sourceNote = c(" Covers educational data ", " Health indicators ")
  )

  with_mocked_bindings(
    perform_request = function(...) mock_data,
    {
      result <- wdi_get_topics()
      expect_equal(result$topic_id, c(1, 2))
      expect_equal(result$topic_name, c("Education", "Health"))
      expect_equal(result$topic_note, c("Covers educational data",
                                        "Health indicators"))
    }
  )
})

test_that("wdi_get_topics converts id to integer", {
  mock_data <- tibble(
    id = c("1", "2"),
    value = c("Education", "Health"),
    sourceNote = c("Covers educational data", "Health indicators")
  )

  with_mocked_bindings(
    perform_request = function(...) mock_data,
    {
      result <- wdi_get_topics()
      expect_type(result$topic_id, "integer")
      expect_equal(result$topic_id, c(1L, 2L))
    }
  )
})

test_that("wdi_get_topics handles empty data gracefully", {
  mock_data <- tibble(
    id = character(),
    value = character(),
    sourceNote = character()
  )

  with_mocked_bindings(
    perform_request = function(...) mock_data,
    {
      result <- wdi_get_topics()
      expect_equal(nrow(result), 0)
    }
  )
})

test_that("wdi_get_topics handles different language inputs", {
  skip_if_offline()

  result <- wdi_get_topics(language = "fr")
  expected_colnames <- c("topic_id", "topic_name", "topic_note")
  expect_true(all(expected_colnames %in% colnames(result)))
})
