# Download all available World Bank indicators

This function retrieves a comprehensive list of all indicators supported
by the World Bank API. The indicators include metadata such as the
indicator ID, name, unit, source, and associated topics. The user can
specify the language of the API response and whether to include
additional details.

## Usage

``` r
wdi_get_indicators(language = "en", per_page = 32500L)
```

## Arguments

- language:

  A character string specifying the language for the request, see
  [wdi_get_languages](https://tidy-intelligence.github.io/r-wbwdi/reference/wdi_get_languages.md).
  Defaults to `"en"`.

- per_page:

  An integer specifying the number of results per page for the API.
  Defaults to 32,500. Must be a value between 1 and 32,500.

## Value

A tibble containing the available indicators and their metadata:

- indicator_id:

  A character string for the ID of the indicator (e.g.,
  "NY.GDP.PCAP.KD").

- indicator_name:

  A character string for the name of the indicator (e.g., "GDP per
  capita, constant prices").

- source_id:

  An integer identifying the data source providing the indicator.

- source_name:

  A character string describing the source of the indicator data.

- source_note:

  A character string providing additional notes about the data source.

- source_organization:

  A character string denoting the organization responsible for the data
  source.

- topics:

  A nested tibble containing (possibly multiple) topics associated with
  the indicator, with two columns: an integer `topic_id` and a character
  `topic_name`.

## Details

This function makes a request to the World Bank API to retrieve metadata
for all available indicators. It processes the response into a tidy
tibble format.

## Examples

``` r
# \donttest{
# Download all supported indicators in English
wdi_get_indicators()
#> # A tibble: 29,299 × 7
#>    indicator_id         indicator_name         source_id source_name source_note
#>    <chr>                <chr>                      <int> <chr>       <chr>      
#>  1 1.0.HCount.1.90usd   Poverty Headcount ($1…        37 LAC Equity… "The pover…
#>  2 1.0.HCount.2.5usd    Poverty Headcount ($2…        37 LAC Equity… "The pover…
#>  3 1.0.HCount.Mid10to50 Middle Class ($10-50 …        37 LAC Equity… "The pover…
#>  4 1.0.HCount.Ofcl      Official Moderate Pov…        37 LAC Equity… "The pover…
#>  5 1.0.HCount.Poor4uds  Poverty Headcount ($4…        37 LAC Equity… "The pover…
#>  6 1.0.HCount.Vul4to10  Vulnerable ($4-10 a d…        37 LAC Equity… "The pover…
#>  7 1.0.PGap.1.90usd     Poverty Gap ($1.90 a …        37 LAC Equity… "The pover…
#>  8 1.0.PGap.2.5usd      Poverty Gap ($2.50 a …        37 LAC Equity… "The pover…
#>  9 1.0.PGap.Poor4uds    Poverty Gap ($4 a day)        37 LAC Equity… "The pover…
#> 10 1.0.PSev.1.90usd     Poverty Severity ($1.…        37 LAC Equity… "The pover…
#> # ℹ 29,289 more rows
#> # ℹ 2 more variables: source_organization <chr>, topics <list>

# Download all supported indicators in Spanish
wdi_get_indicators(language = "es")
#> # A tibble: 29,299 × 7
#>    indicator_id         indicator_name         source_id source_name source_note
#>    <chr>                <chr>                      <int> <chr>       <chr>      
#>  1 1.0.HCount.1.90usd   "Tasa de Incidencia d…        37 ""          "Tasa de I…
#>  2 1.0.HCount.2.5usd    "Tasa de Incidencia d…        37 ""          "Tasa de I…
#>  3 1.0.HCount.Mid10to50 "Tasa de Incidencia d…        37 ""          "Tasa de I…
#>  4 1.0.HCount.Ofcl      "Tasa Oficial de la P…        37 ""          "Tasa de I…
#>  5 1.0.HCount.Poor4uds  "Tasa de Incidencia d…        37 ""          "Tasa de I…
#>  6 1.0.HCount.Vul4to10  "Tasa de incidencia d…        37 ""          "Tasa de I…
#>  7 1.0.PGap.1.90usd     "Brecha de Pobreza ($…        37 ""          "La Brecha…
#>  8 1.0.PGap.2.5usd      "Brecha de Pobreza ($…        37 ""          "La Brecha…
#>  9 1.0.PGap.Poor4uds    "Brecha de Pobreza ($…        37 ""          "La Brecha…
#> 10 1.0.PSev.1.90usd     "Severidad de la Pobr…        37 ""          "El índice…
#> # ℹ 29,289 more rows
#> # ℹ 2 more variables: source_organization <chr>, topics <list>
# }
```
