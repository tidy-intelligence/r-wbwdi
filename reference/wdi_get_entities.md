# Download all countries and regions from the World Bank API

This function retrieves information about entities (countries and
regions) from the World Bank API. It returns a tibble containing various
details such as the entity's ID, ISO2 code, name, region information,
lending type, capital city, and coordinates.

## Usage

``` r
wdi_get_entities(language = "en", per_page = 1000)
```

## Arguments

- language:

  A character string specifying the language for the API response.
  Defaults to `"en"` (English). Other supported options include `"es"`
  (Spanish), `"fr"` (French), and others depending on the API.

- per_page:

  An integer specifying the number of records to fetch per request.
  Defaults to `1000`.

## Value

A tibble with the following columns:

- entity_id:

  A character string representing the entity's unique identifier.

- entity_name:

  A character string for the name of the entity.

- entity_iso2code:

  A character string for the ISO2 country code.

- entity_type:

  A character string for the type of the entity ("country" or "region").

- region_id:

  A character string representing the region's unique identifier.

- region_name:

  A character string for the name of the region.

- region_iso2code:

  A character string for the ISO2 region code.

- admin_region_id:

  A character string representing the administrative region's unique
  identifier.

- admin_region_name:

  A character string for the name of the administrative region.

- admin_region_iso2code:

  A character string for the ISO2 code of the administrative region.

- income_level_id:

  A character string representing the entity's income level.

- income_level_name:

  A character string for the name of the income level.

- income_level_iso2code:

  A character string for the ISO2 code of the income level.

- lending_type_id:

  A character string representing the lending type's unique identifier.

- lending_type_name:

  A character string for the name of the lending type.

- lending_type_iso2code:

  A character string for the ISO2 code of the lending type.

- capital_city:

  A character string for the name of the capital city.

- longitude:

  A numeric value for the longitude of the entity.

- latitude:

  A numeric value for the latitude of the entity.

## Details

This function sends a request to the World Bank API to retrieve data for
all supported entities in the specified language. The data is then
processed into a tidy format and includes information about the country,
such as its ISO code, capital city, geographical coordinates, and
additional metadata about regions, income levels, and lending types.

## Examples

``` r
# Download all entities in English
wdi_get_entities()
#> # A tibble: 296 × 19
#>    entity_id entity_iso2code entity_type capital_city     entity_name  region_id
#>    <chr>     <chr>           <chr>       <chr>            <chr>        <chr>    
#>  1 ABW       AW              country     Oranjestad       Aruba        LCN      
#>  2 AFE       ZH              aggregates  NA               Africa East… NA       
#>  3 AFG       AF              country     Kabul            Afghanistan  MEA      
#>  4 AFR       A9              aggregates  NA               Africa       NA       
#>  5 AFW       ZI              aggregates  NA               Africa West… NA       
#>  6 AGO       AO              country     Luanda           Angola       SSF      
#>  7 ALB       AL              country     Tirane           Albania      ECS      
#>  8 AND       AD              country     Andorra la Vella Andorra      ECS      
#>  9 ARB       1A              aggregates  NA               Arab World   NA       
#> 10 ARE       AE              country     Abu Dhabi        United Arab… MEA      
#> # ℹ 286 more rows
#> # ℹ 13 more variables: region_iso2code <chr>, region_name <chr>,
#> #   admin_region_id <chr>, admin_region_iso2code <chr>,
#> #   admin_region_name <chr>, income_level_id <chr>,
#> #   income_level_iso2code <chr>, income_level_name <chr>,
#> #   lending_type_id <chr>, lending_type_iso2code <chr>,
#> #   lending_type_name <chr>, longitude <dbl>, latitude <dbl>

# Download all entities in Spanish
wdi_get_entities(language = "zh")
#> # A tibble: 296 × 19
#>    entity_id entity_iso2code entity_type capital_city entity_name      region_id
#>    <chr>     <chr>           <chr>       <chr>        <chr>            <chr>    
#>  1 ABW       AW              country     奥拉涅斯塔德 阿鲁巴           LCN      
#>  2 AFE       ZH              country     NA           NA               NA       
#>  3 AFG       AF              country     喀布尔       阿富汗           MEA      
#>  4 AFR       A9              country     NA           NA               NA       
#>  5 AFW       ZI              country     NA           NA               NA       
#>  6 AGO       AO              country     罗安达       安哥拉           SSF      
#>  7 ALB       AL              country     地拉那       阿尔巴尼亚       ECS      
#>  8 AND       AD              country     安道尔城     安道尔共和国     ECS      
#>  9 ARB       1A              country     NA           阿拉伯联盟国家   NA       
#> 10 ARE       AE              country     阿布扎比     阿拉伯联合酋长国 MEA      
#> # ℹ 286 more rows
#> # ℹ 13 more variables: region_iso2code <chr>, region_name <chr>,
#> #   admin_region_id <chr>, admin_region_iso2code <chr>,
#> #   admin_region_name <chr>, income_level_id <chr>,
#> #   income_level_iso2code <chr>, income_level_name <chr>,
#> #   lending_type_id <chr>, lending_type_iso2code <chr>,
#> #   lending_type_name <chr>, longitude <dbl>, latitude <dbl>
```
