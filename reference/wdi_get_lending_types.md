# Download lending types from the World Bank API

This function returns a tibble of supported lending types for querying
the World Bank API. The lending types classify countries based on the
financial terms available to them from the World Bank.

## Usage

``` r
wdi_get_lending_types(language = "en")
```

## Source

https://api.worldbank.org/v2/lendingTypes

## Arguments

- language:

  A character string specifying the language code for the API response
  (default is "en" for English).

## Value

A tibble with columns that typically include:

- lending_type_id:

  An integer for the lending type.

- lending_type_iso2code:

  A character string for the ISO2 code of the lending type.

- lending_type_name:

  A description of the lending type (e.g., "IBRD", "IDA").

## Details

This function provides a reference for the supported lending types,
which classify countries according to the financial terms they are
eligible for under World Bank programs. The language parameter allows
the results to be returned in different languages as supported by the
API.

## Examples

``` r
# Download all lending types in English
wdi_get_lending_types()
#> # A tibble: 4 × 3
#>   lending_type_id lending_type_iso2code lending_type_name
#>   <chr>           <chr>                 <chr>            
#> 1 IBD             XF                    IBRD             
#> 2 IDB             XH                    Blend            
#> 3 IDX             XI                    IDA              
#> 4 LNX             XX                    Not classified   
```
