# Download languages from the World Bank API

This function returns a tibble of supported languages for querying the
World Bank API. The supported languages include English, Spanish,
French, Arabic, and Chinese, etc.

## Usage

``` r
wdi_get_languages()
```

## Source

https://api.worldbank.org/v2/languages

## Value

A tibble with three columns:

- language_code:

  A character string representing the language code (e.g., "en" for
  English).

- language_name:

  A character string representing the description of the language (e.g.,
  "English").

- native_form:

  A character string representing the native form of the language (e.g.,
  "English").

## Details

This function provides a simple reference for the supported languages
when querying the World Bank API.

## Examples

``` r
# Download all languages
wdi_get_languages()
#> # A tibble: 23 × 3
#>    language_code language_name native_form     
#>    <chr>         <chr>         <chr>           
#>  1 en            English       English         
#>  2 es            Spanish       Español         
#>  3 fr            French        Français        
#>  4 ar            Arabic        عربي            
#>  5 zh            Chinese       中文            
#>  6 bg            Bulgarian     Български       
#>  7 de            German        Deutsch         
#>  8 hi            Hindi         हिंदी            
#>  9 id            Indonesian    Bahasa indonesia
#> 10 ja            Japanese      日本語          
#> # ℹ 13 more rows
```
