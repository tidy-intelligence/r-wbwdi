# Download World Bank indicator data for specific entities and time periods

This function retrieves indicator data from the World Bank API for a
specified set of entities and indicators. The user can specify one or
more indicators, a date range, and other options to tailor the request.
The data is processed and returned in a tidy format, including country,
indicator, date, and value fields.

## Usage

``` r
wdi_get(
  entities,
  indicators,
  start_year = NULL,
  end_year = NULL,
  most_recent_only = FALSE,
  frequency = "annual",
  language = "en",
  per_page = 10000L,
  progress = TRUE,
  source = NULL,
  format = "long"
)
```

## Arguments

- entities:

  A character vector of ISO 2 or ISO 3-country codes, or `"all"` to
  retrieve data for all entities.

- indicators:

  A character vector specifying one or more World Bank indicators to
  download (e.g., c("NY.GDP.PCAP.KD", "SP.POP.TOTL")).

- start_year:

  Optional integer. The starting date for the data as a year.

- end_year:

  Optional integer. The ending date for the data as a year.

- most_recent_only:

  A logical value indicating whether to download only the most recent
  value. In case of `TRUE`, it overrides `start_year` and `end_year`.
  Defaults to `FALSE`.

- frequency:

  A character string specifying the frequency of the data ("annual",
  "quarter", "month"). Defaults to "annual".

- language:

  A character string specifying the language for the request, see
  [wdi_get_languages](https://tidy-intelligence.github.io/r-wbwdi/reference/wdi_get_languages.md).
  Defaults to `"en"`.

- per_page:

  An integer specifying the number of results per page for the API.
  Defaults to 10,000.

- progress:

  A logical value indicating whether to show progress messages during
  the data download and parsing. Defaults to `TRUE`.

- source:

  An integer value specifying the data source, see
  [wdi_get_sources](https://tidy-intelligence.github.io/r-wbwdi/reference/wdi_get_sources.md).

- format:

  A character value specifying whether the data is returned in `"long"`
  or `"wide"` format. Defaults to `"long"`.

## Value

A tibble with the following columns:

- entity_id:

  The ISO 3-country code of the country or aggregate for which the data
  was retrieved.

- indicator_id:

  The ID of the indicator (e.g., "NY.GDP.PCAP.KD").

- year:

  The year of the indicator data as an integer.

- quarter:

  Optional. The quarter of the indicator data as integer.

- month:

  Optional. The month of the indicator data as integer.

- value:

  The value of the indicator for the given country and date.

## Details

This function constructs a request URL for the World Bank API, retrieves
the relevant data for the given entities and indicators, and processes
the response into a tidy format. The user can optionally specify a date
range, and the function will handle requests for multiple pages if
necessary. If the `progress` parameter is `TRUE`, messages will be
displayed during the request and parsing process.

The function supports downloading multiple indicators by sending
individual API requests for each indicator and then combining the
results into a single tidy data frame.

## Examples

``` r
# \donttest{
# Download single indicator for multiple entities
wdi_get(c("USA", "CAN", "GBR"), "NY.GDP.PCAP.KD")
#> # A tibble: 198 × 4
#>    entity_id indicator_id    year  value
#>    <chr>     <chr>          <int>  <dbl>
#>  1 CAN       NY.GDP.PCAP.KD  1960 15432.
#>  2 GBR       NY.GDP.PCAP.KD  1960 15324.
#>  3 USA       NY.GDP.PCAP.KD  1960 18899.
#>  4 CAN       NY.GDP.PCAP.KD  1961 15606.
#>  5 GBR       NY.GDP.PCAP.KD  1961 15618.
#>  6 USA       NY.GDP.PCAP.KD  1961 19016.
#>  7 CAN       NY.GDP.PCAP.KD  1962 16456.
#>  8 GBR       NY.GDP.PCAP.KD  1962 15657.
#>  9 USA       NY.GDP.PCAP.KD  1962 19868.
#> 10 CAN       NY.GDP.PCAP.KD  1963 17008.
#> # ℹ 188 more rows

# Download single indicator for a specific time frame
wdi_get(c("USA", "CAN", "GBR"), "DPANUSSPB",
        start_year = 2012, end_year = 2013)
#> # A tibble: 6 × 4
#>   entity_id indicator_id  year value
#>   <chr>     <chr>        <int> <dbl>
#> 1 CAN       DPANUSSPB     2012 1.000
#> 2 GBR       DPANUSSPB     2012 0.631
#> 3 USA       DPANUSSPB     2012 1    
#> 4 CAN       DPANUSSPB     2013 1.03 
#> 5 GBR       DPANUSSPB     2013 0.640
#> 6 USA       DPANUSSPB     2013 1    

# Download single indicator for monthly frequency
wdi_get("AUT", "DPANUSSPB",
        start_year = 2012, end_year = 2015, frequency = "month")
#> # A tibble: 48 × 5
#>    entity_id indicator_id  year month value
#>    <chr>     <chr>        <int> <int> <dbl>
#>  1 AUT       DPANUSSPB     2012     1 0.775
#>  2 AUT       DPANUSSPB     2012     2 0.755
#>  3 AUT       DPANUSSPB     2012     3 0.757
#>  4 AUT       DPANUSSPB     2012     4 0.760
#>  5 AUT       DPANUSSPB     2012     5 0.782
#>  6 AUT       DPANUSSPB     2012     6 0.797
#>  7 AUT       DPANUSSPB     2012     7 0.814
#>  8 AUT       DPANUSSPB     2012     8 0.806
#>  9 AUT       DPANUSSPB     2012     9 0.777
#> 10 AUT       DPANUSSPB     2012    10 0.771
#> # ℹ 38 more rows

# Download single indicator for quarterly frequency
wdi_get("NGA", "DT.DOD.DECT.CD.TL.US",
        start_year = 2012, end_year = 2015, frequency = "quarter")
#> # A tibble: 16 × 5
#>    entity_id indicator_id          year quarter        value
#>    <chr>     <chr>                <int>   <int>        <dbl>
#>  1 NGA       DT.DOD.DECT.CD.TL.US  2012       1  8235000000 
#>  2 NGA       DT.DOD.DECT.CD.TL.US  2012       2  8374010000 
#>  3 NGA       DT.DOD.DECT.CD.TL.US  2012       3  8587040000 
#>  4 NGA       DT.DOD.DECT.CD.TL.US  2012       4  8883380000 
#>  5 NGA       DT.DOD.DECT.CD.TL.US  2013       1  9195080000 
#>  6 NGA       DT.DOD.DECT.CD.TL.US  2013       2  9477070000 
#>  7 NGA       DT.DOD.DECT.CD.TL.US  2013       3 10817130000 
#>  8 NGA       DT.DOD.DECT.CD.TL.US  2013       4 11402000000 
#>  9 NGA       DT.DOD.DECT.CD.TL.US  2014       1 11746100000 
#> 10 NGA       DT.DOD.DECT.CD.TL.US  2014       2 11957200000 
#> 11 NGA       DT.DOD.DECT.CD.TL.US  2014       3 12002828000 
#> 12 NGA       DT.DOD.DECT.CD.TL.US  2014       4 12138750000 
#> 13 NGA       DT.DOD.DECT.CD.TL.US  2015       1 11781991990.
#> 14 NGA       DT.DOD.DECT.CD.TL.US  2015       2 12667757149.
#> 15 NGA       DT.DOD.DECT.CD.TL.US  2015       3 12966561500 
#> 16 NGA       DT.DOD.DECT.CD.TL.US  2015       4 13040050000 

# Download single indicator for all entities and disable progress bar
wdi_get("all", "NY.GDP.PCAP.KD", progress = FALSE)
#> # A tibble: 17,556 × 4
#>    entity_id indicator_id    year value
#>    <chr>     <chr>          <int> <dbl>
#>  1 AFE       NY.GDP.PCAP.KD  1960 1186.
#>  2 AFW       NY.GDP.PCAP.KD  1960 1130.
#>  3 ARB       NY.GDP.PCAP.KD  1960   NA 
#>  4 CSS       NY.GDP.PCAP.KD  1960 4450.
#>  5 CEB       NY.GDP.PCAP.KD  1960   NA 
#>  6 EAR       NY.GDP.PCAP.KD  1960 1067.
#>  7 EAS       NY.GDP.PCAP.KD  1960 1147.
#>  8 EAP       NY.GDP.PCAP.KD  1960  325.
#>  9 TEA       NY.GDP.PCAP.KD  1960  330.
#> 10 EMU       NY.GDP.PCAP.KD  1960 9952.
#> # ℹ 17,546 more rows

# Download multiple indicators for multiple entities
wdi_get(c("USA", "CAN", "GBR"), c("NY.GDP.PCAP.KD", "SP.POP.TOTL"))
#> # A tibble: 396 × 4
#>    entity_id indicator_id    year  value
#>    <chr>     <chr>          <int>  <dbl>
#>  1 CAN       NY.GDP.PCAP.KD  1960 15432.
#>  2 GBR       NY.GDP.PCAP.KD  1960 15324.
#>  3 USA       NY.GDP.PCAP.KD  1960 18899.
#>  4 CAN       NY.GDP.PCAP.KD  1961 15606.
#>  5 GBR       NY.GDP.PCAP.KD  1961 15618.
#>  6 USA       NY.GDP.PCAP.KD  1961 19016.
#>  7 CAN       NY.GDP.PCAP.KD  1962 16456.
#>  8 GBR       NY.GDP.PCAP.KD  1962 15657.
#>  9 USA       NY.GDP.PCAP.KD  1962 19868.
#> 10 CAN       NY.GDP.PCAP.KD  1963 17008.
#> # ℹ 386 more rows

# Download indicators for different sources
wdi_get("DEU", "NY.GDP.PCAP.KD", source = 2)
#> # A tibble: 66 × 4
#>    entity_id indicator_id    year  value
#>    <chr>     <chr>          <int>  <dbl>
#>  1 DEU       NY.GDP.PCAP.KD  1960 12607.
#>  2 DEU       NY.GDP.PCAP.KD  1961 13048.
#>  3 DEU       NY.GDP.PCAP.KD  1962 13532.
#>  4 DEU       NY.GDP.PCAP.KD  1963 13774.
#>  5 DEU       NY.GDP.PCAP.KD  1964 14570.
#>  6 DEU       NY.GDP.PCAP.KD  1965 15204.
#>  7 DEU       NY.GDP.PCAP.KD  1966 15502.
#>  8 DEU       NY.GDP.PCAP.KD  1967 15380.
#>  9 DEU       NY.GDP.PCAP.KD  1968 16180.
#> 10 DEU       NY.GDP.PCAP.KD  1969 17243.
#> # ℹ 56 more rows
wdi_get("DEU", "SG.LAW.INDX", source = 14)
#> ! Error code: 120
#> The provided parameter value is not valid
#> Read more at <https://datahelpdesk.worldbank.org/knowledgebase/articles/898620-api-error-codes>
#> # A tibble: 0 × 4
#> # ℹ 4 variables: entity_id <chr>, indicator_id <chr>, year <int>, value <dbl>

# Download indicators in wide format
wdi_get(c("USA", "CAN", "GBR"), c("NY.GDP.PCAP.KD"),
        format = "wide")
#> # A tibble: 198 × 3
#>    entity_id  year NY.GDP.PCAP.KD
#>    <chr>     <int>          <dbl>
#>  1 CAN        1960         15432.
#>  2 GBR        1960         15324.
#>  3 USA        1960         18899.
#>  4 CAN        1961         15606.
#>  5 GBR        1961         15618.
#>  6 USA        1961         19016.
#>  7 CAN        1962         16456.
#>  8 GBR        1962         15657.
#>  9 USA        1962         19868.
#> 10 CAN        1963         17008.
#> # ℹ 188 more rows
wdi_get(c("USA", "CAN", "GBR"), c("NY.GDP.PCAP.KD", "SP.POP.TOTL"),
        format = "wide")
#> # A tibble: 198 × 4
#>    entity_id  year NY.GDP.PCAP.KD SP.POP.TOTL
#>    <chr>     <int>          <dbl>       <dbl>
#>  1 CAN        1960         15432.    17909356
#>  2 GBR        1960         15324.    52400000
#>  3 USA        1960         18899.   180671000
#>  4 CAN        1961         15606.    18271000
#>  5 GBR        1961         15618.    52800000
#>  6 USA        1961         19016.   183691000
#>  7 CAN        1962         16456.    18614000
#>  8 GBR        1962         15657.    53250000
#>  9 USA        1962         19868.   186538000
#> 10 CAN        1963         17008.    18964000
#> # ℹ 188 more rows

# Download most recent value only
wdi_get("USA", "SP.POP.TOTL", most_recent_only = TRUE)
#> # A tibble: 1 × 4
#>   entity_id indicator_id  year     value
#>   <chr>     <chr>        <int>     <dbl>
#> 1 USA       SP.POP.TOTL   2024 340110988
# }
```
