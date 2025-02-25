test_that("wdi_search returns rows with specified keywords in any column", {
  data <- tibble::tibble(
    id = 1:4,
    text = c("apple pie", NA, "", "banana split"),
    description = c("A delicious apple dessert", "Tropical fruit mix", "", NA),
    nested = list(list("apple", "orange"), list(), list(), list("banana"))
  )

  # Test 1: Search for a keyword in all columns
  result <- wdi_search(data, keywords = c("apple"))
  expect_equal(nrow(result), 1)

  # Test 2: Search for multiple keywords across all columns
  result <- wdi_search(data, keywords = c("apple", "berry"))
  expect_equal(nrow(result), 1)

  # Test 3: Search for keywords only in a specific column
  result <- wdi_search(data, keywords = c("banana"), columns = "text")
  expect_equal(nrow(result), 1)

  # Test 4: Search for keywords in multiple specified columns
  result <- wdi_search(data, keywords = c("pie"),
                       columns = c("text", "description"))
  expect_equal(nrow(result), 1)

  # Test 5: Case-insensitive search
  result <- wdi_search(data, keywords = c("APPLE"))
  expect_equal(nrow(result), 1)

  # Test 6: Keyword not present in any row
  result <- wdi_search(data, keywords = c("mango"))
  expect_equal(nrow(result), 0)

  # Test 7: Nested column search
  result <- wdi_search(data, keywords = c("orange"))
  expect_equal(nrow(result), 1)

  # Test 8: All columns searched by default if columns parameter is NULL
  result <- wdi_search(data, keywords = c("banana"))
  expect_equal(nrow(result), 1)

  # Test 9: Empty keywords vector
  result <- wdi_search(data, keywords = character(0))
  expect_equal(nrow(result), 0)

  # Test 10: No relevant keyword
  result <- wdi_search(data, keywords = c("xxx"))
  expect_equal(nrow(result), 0)

  # Test 11: All rows match when keyword is common
  result <- wdi_search(data, keywords = c("a"))
  expect_equal(nrow(result), 3)

  # Test 12: Search with NULL columns explicitly
  result <- wdi_search(data, keywords = c("tropical"), columns = NULL)
  expect_equal(nrow(result), 1)
  expect_equal(result$id, 2)

  # Test 13: Search for a keyword that doesn't exist in empty/null cells
  result <- wdi_search(data, keywords = c("mango"))
  expect_equal(nrow(result), 0)

  # Test 14: Search in columns with NULL and empty lists
  result <- wdi_search(data, keywords = c("banana"))
  expect_equal(nrow(result), 1)
  expect_equal(result$id, 4)

})
