# Search for Keywords in Data Frame Columns

This function searches for specified keywords across columns in a data
frame and returns only the rows where at least one keyword appears in
any of the specified columns. It supports nested columns (lists within
columns) and provides the option to limit the search to specific
columns.

## Usage

``` r
wdi_search(data, keywords, columns = NULL)
```

## Arguments

- data:

  A data frame to search. It can include nested columns (lists within
  columns).

- keywords:

  A character vector of keywords to search for within the specified
  columns. The search is case-insensitive.

- columns:

  Optional. A character vector of column names to limit the search to
  specific columns. If `NULL`, all columns in `data` will be searched.

## Value

A data frame containing only the rows where at least one keyword is
found in the specified columns. The returned data frame has the same
structure as `data`.

## Examples

``` r
# \donttest{
# Download indicators
indicators <- wdi_get_indicators()

# Search for keywords "inequality" or "gender" across all columns
wdi_search(
  indicators,
  keywords = c("inequality", "gender")
)
#> # A tibble: 1,678 × 7
#>    indicator_id      indicator_name            source_id source_name source_note
#>    <chr>             <chr>                         <int> <chr>       <chr>      
#>  1 1.0.PSev.1.90usd  Poverty Severity ($1.90 …        37 LAC Equity… The povert…
#>  2 1.0.PSev.2.5usd   Poverty Severity ($2.50 …        37 LAC Equity… The povert…
#>  3 1.0.PSev.Poor4uds Poverty Severity ($4 a d…        37 LAC Equity… The povert…
#>  4 1.1.PSev.1.90usd  Poverty Severity ($1.90 …        37 LAC Equity… The povert…
#>  5 1.1.PSev.2.5usd   Poverty Severity ($2.50 …        37 LAC Equity… The povert…
#>  6 1.1.PSev.Poor4uds Poverty Severity ($4 a d…        37 LAC Equity… The povert…
#>  7 1.2.PSev.1.90usd  Poverty Severity ($1.90 …        37 LAC Equity… The povert…
#>  8 1.2.PSev.2.5usd   Poverty Severity ($2.50 …        37 LAC Equity… The povert…
#>  9 1.2.PSev.Poor4uds Poverty Severity ($4 a d…        37 LAC Equity… The povert…
#> 10 2.0.cov.Cel       Coverage: Mobile Phone           37 LAC Equity… The covera…
#> # ℹ 1,668 more rows
#> # ℹ 2 more variables: source_organization <chr>, topics <list>

# Search for keywords only within the "indicator_name" column
wdi_search(
  indicators,
  keywords = c("inequality", "gender"),
  columns = c("indicator_name")
)
#> # A tibble: 466 × 7
#>    indicator_id         indicator_name         source_id source_name source_note
#>    <chr>                <chr>                      <int> <chr>       <chr>      
#>  1 2.3_GIR.GPI          "Gender parity index …        34 Global Par… "Ratio of …
#>  2 2.6_PCR.GPI          "Gender parity index …        34 Global Par… "Ratio of …
#>  3 BI.EMP.PWRK.PB.FE.ZS "Public sector employ…        64 Worldwide …  NA        
#>  4 BI.EMP.PWRK.PB.MA.ZS "Public sector employ…        64 Worldwide …  NA        
#>  5 BI.EMP.TOTL.PB.FE.ZS "Public sector employ…        64 Worldwide …  NA        
#>  6 BI.EMP.TOTL.PB.MA.ZS "Public sector employ…        64 Worldwide …  NA        
#>  7 BI.WAG.PREM.PB.FE    "Public sector wage p…        64 Worldwide …  NA        
#>  8 BI.WAG.PREM.PB.FM    "P-Value: Public sect…        64 Worldwide …  NA        
#>  9 BI.WAG.PREM.PB.FM.CA "P-Value: Gender wage…        64 Worldwide …  NA        
#> 10 BI.WAG.PREM.PB.FM.ED "P-Value: Gender wage…        64 Worldwide …  NA        
#> # ℹ 456 more rows
#> # ℹ 2 more variables: source_organization <chr>, topics <list>
# }
```
