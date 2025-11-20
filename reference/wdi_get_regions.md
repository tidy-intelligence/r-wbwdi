# Download regions from the World Bank API

This function returns a tibble of supported regions for querying the
World Bank API.The regions include various geographic areas covered by
the World Bank's datasets.

## Usage

``` r
wdi_get_regions(language = "en")
```

## Source

https://api.worldbank.org/v2/region

## Arguments

- language:

  A character string specifying the language code for the API response
  (default is "en" for English).

## Value

A tibble with the following columns:

- region_id:

  An integer identifier for each region.

- region_code:

  A character string representing the region code.

- region_iso2code:

  A character string representing the ISO2 code for the region.

- region_name:

  A character string representing the name of the region, in the
  specified language.

## Details

This function provides a reference for the supported regions, which are
important for refining queries related to geographic data in the World
Bank's datasets. The `region_id` column is unique for seven key regions.

## Examples

``` r
# Download all regions
wdi_get_regions()
#> # A tibble: 44 × 4
#>    region_id region_code region_iso2code region_name                            
#>        <int> <chr>       <chr>           <chr>                                  
#>  1        NA AFE         ZH              Africa Eastern and Southern            
#>  2        NA AFR         A9              Africa                                 
#>  3        NA AFW         ZI              Africa Western and Central             
#>  4        NA ARB         1A              Arab World                             
#>  5        NA CAA         C9              Sub-Saharan Africa (IFC classification)
#>  6        NA CEA         C4              East Asia and the Pacific (IFC classif…
#>  7        NA CEB         B8              Central Europe and the Baltics         
#>  8        NA CEU         C5              Europe and Central Asia (IFC classific…
#>  9        NA CLA         C6              Latin America and the Caribbean (IFC c…
#> 10        NA CME         C7              Middle East and North Africa (IFC clas…
#> # ℹ 34 more rows
```
