# Download income levels from the World Bank API

This function returns a tibble of supported income levels for querying
the World Bank API. The income levels categorize countries based on
their gross national income per capita.

## Usage

``` r
wdi_get_income_levels(language = "en")
```

## Source

https://api.worldbank.org/v2/incomeLevels

## Arguments

- language:

  A character string specifying the language code for the API response
  (default is "en" for English).

## Value

A tibble with columns that typically include:

- income_level_id:

  An integer identifier for the income level.

- income_level_iso2code:

  A character string representing the ISO2 code for the income level.

- income_level_name:

  The description of the income level (e.g., "Low income", "High
  income").

## Details

This function provides a reference for the supported income levels,
which categorize countries according to their income group as defined by
the World Bank. The language parameter allows the results to be returned
in different languages as supported by the API.

## Examples

``` r
# Download all income levels in English
wdi_get_income_levels()
#> # A tibble: 7 × 3
#>   income_level_id income_level_iso2code income_level_name  
#>   <chr>           <chr>                 <chr>              
#> 1 HIC             XD                    High income        
#> 2 INX             XY                    Not classified     
#> 3 LIC             XM                    Low income         
#> 4 LMC             XN                    Lower middle income
#> 5 LMY             XO                    Low & middle income
#> 6 MIC             XP                    Middle income      
#> 7 UMC             XT                    Upper middle income
```
