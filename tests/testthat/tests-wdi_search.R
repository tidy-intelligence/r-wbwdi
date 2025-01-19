test_that("wdi_search returns rows with specified keywords in any column", {
  data <- data.frame(
    id = 1:3,
    text = c("apple pie", "banana split", "cherry tart"),
    description = c("A delicious apple dessert", "Tropical fruit mix",
                    "A tart with cherry flavor"),
    nested = I(list(list("apple", "orange"),
                    list("banana", "peach"),
                    list("berry", "tart"))),
    stringsAsFactors = FALSE
  )

  # Test 1: Search for a keyword in all columns
  result <- wdi_search(data, keywords = c("apple"))
  expect_equal(nrow(result), 1)

  # Test 2: Search for multiple keywords across all columns
  result <- wdi_search(data, keywords = c("apple", "berry"))
  expect_equal(nrow(result), 2)

  # Test 3: Search for keywords only in a specific column
  result <- wdi_search(data, keywords = c("banana"), columns = "text")
  expect_equal(nrow(result), 1)

  # Test 4: Search for keywords in multiple specified columns
  result <- wdi_search(data, keywords = c("tart"),
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
  result <- wdi_search(data, keywords = c("peach"))
  expect_equal(nrow(result), 1)

  # Test 9: Empty keywords vector
  result <- wdi_search(data, keywords = character(0))
  expect_equal(nrow(result), 0)
})
