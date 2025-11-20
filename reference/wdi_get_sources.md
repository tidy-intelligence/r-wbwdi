# Download data sources from the World Bank API

This function returns a tibble of supported data sources for querying
the World Bank API. The data sources include various databases and
datasets provided by the World Bank.

## Usage

``` r
wdi_get_sources(language = "en")
```

## Source

https://api.worldbank.org/v2/sources

## Arguments

- language:

  A character string specifying the language code for the API response
  (default is "en" for English).

## Value

A tibble with six columns:

- source_id:

  An integer identifier for the data source.

- source_code:

  A character string for the source code.

- source_name:

  The name of the data source (e.g., "World Development Indicators").

- update_date:

  The last update date of the data source.

- is_data_available:

  A boolean indicating whether data is available.

- is_metadata_available:

  A boolean indicating whether metadata is available.

- concepts:

  The number of concepts defined for the data source.

## Details

This function provides a reference for the supported data sources and
their metadata when querying the World Bank API. The columns
`is_data_available` and `is_metadata_available` are logical values
derived from the API response, where "Y" indicates availability.

## Examples

``` r
# Download all available data sources in English
wdi_get_sources()
#> # A tibble: 71 × 7
#>    source_id source_code source_name               update_date is_data_available
#>        <int> <chr>       <chr>                     <date>      <lgl>            
#>  1         1 DBS         Doing Business            2021-08-18  TRUE             
#>  2         2 WDI         World Development Indica… 2025-10-07  TRUE             
#>  3         3 WGI         Worldwide Governance Ind… 2024-11-05  TRUE             
#>  4         5 SNM         Subnational Malnutrition… 2016-03-21  TRUE             
#>  5         6 IDS         International Debt Stati… 2025-02-26  TRUE             
#>  6        11 ADI         Africa Development Indic… 2013-02-22  TRUE             
#>  7        12 EDS         Education Statistics      2024-06-25  TRUE             
#>  8        13 ESY         Enterprise Surveys        2022-03-25  TRUE             
#>  9        14 GDS         Gender Statistics         2025-11-11  TRUE             
#> 10        15 GEM         Global Economic Monitor   2025-11-13  TRUE             
#> # ℹ 61 more rows
#> # ℹ 2 more variables: is_metadata_available <lgl>, concepts <int>
```
