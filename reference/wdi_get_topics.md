# Download topics from the World Bank API

This function returns a tibble of supported topics for querying the
World Bank API. Topics represent the broad subject areas covered by the
World Bank's datasets.

## Usage

``` r
wdi_get_topics(language = "en")
```

## Source

https://api.worldbank.org/v2/topics

## Arguments

- language:

  A character string specifying the language code for the API response
  (default is "en" for English).

## Value

A tibble with three columns:

- id:

  The unique identifier for the topic.

- value:

  The name of the topic (e.g., "Education", "Health").

- source_note:

  A brief description or note about the topic.

## Details

This function provides a reference for the supported topics that can be
used to refine your queries when accessing the World Bank API. Topics
represent different areas of focus for data analysis.

## Examples

``` r
# Download all available topics in English
wdi_get_topics()
#> # A tibble: 21 × 3
#>    topic_id topic_name                      topic_note                          
#>       <int> <chr>                           <chr>                               
#>  1        1 Agriculture & Rural Development "For the 70 percent of the world's …
#>  2        2 Aid Effectiveness               "Aid effectiveness is the impact th…
#>  3        3 Economy & Growth                "Economic growth is central to econ…
#>  4        4 Education                       "Education is one of the most power…
#>  5        5 Energy & Mining                 "The world economy needs ever-incre…
#>  6        6 Environment                     "Natural and man-made environmental…
#>  7        7 Financial Sector                "An economy's financial markets are…
#>  8        8 Health                          "Improving health is central to the…
#>  9        9 Infrastructure                  "Infrastructure helps determine the…
#> 10       10 Social Protection & Labor       "The supply of labor available in a…
#> # ℹ 11 more rows
```
