# Internal function to perform API requests to the World Bank API

This function constructs and sends a request to the specified World Bank
API resource, with options to specify the language, the number of
results per page, a date range, and the data source. It also supports
paginated requests and progress tracking.

## Usage

``` r
perform_request(
  resource,
  language = NULL,
  per_page = 10000L,
  date = NULL,
  most_recent_only = NULL,
  source = NULL,
  progress = FALSE,
  base_url = "https://api.worldbank.org/v2/",
  max_tries = 10L
)
```

## Arguments

- resource:

  A character string specifying the resource endpoint for the World Bank
  API (e.g., "incomeLevels", "lendingTypes").

- language:

  A character string specifying the language code for the API response.
  Defaults to NULL.

- per_page:

  An integer specifying the number of results per page for the API.
  Defaults to 10,000. Must be a value between 1 and 32,500.

- date:

  A character string specifying the date range of the data to be
  retrieved (e.g., "2000:2020"). If NULL (default), no date filtering is
  applied.

- source:

  A character string specifying the data source for the API request. If
  NULL (default), no specific source is selected.

- progress:

  A logical value indicating whether to display a progress bar for
  paginated requests. Defaults to FALSE.

- base_url:

  A character string specifying the base URL of the World Bank API
  (default is "https://api.worldbank.org/v2").

- max_tries:

  An integer specifying the number of attempts for the API request.

## Value

A list containing the parsed JSON response from the API. If the response
contains multiple pages, the results are combined into a single list. If
the API returns an error, it provides the relevant error message and
documentation.

## Details

This internal helper function constructs the request URL using the base
URL, language, resource, and other optional parameters (such as date and
source), and performs the API request. For paginated results, it
iterates through all pages and consolidates the data into a single
output. The function handles API errors, providing detailed error
messages when available.
