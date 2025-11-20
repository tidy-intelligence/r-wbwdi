# Using \`wbwdi\` to access World Development Indicators

``` r
library(wbwdi)
```

The `wbwdi` package provides a modern and flexible interface for
accessing the World Bank’s [World Development Indicators
(WDI)](https://datatopics.worldbank.org/world-development-indicators/).
With `wbwdi`, you can download data for multiple indicators and entities
in a single function call, benefit from progress bars, and receive the
output in a tidy data format, making it ideal for further analysis with
other data sources.

## Listing Supported Indicators

The `wbwdi` package allows you to retrieve a full list of all supported
indicators from the World Bank [Indicators
API](https://datahelpdesk.worldbank.org/knowledgebase/articles/889392-about-the-indicators-api-documentation).
Each indicator is accompanied by metadata such as its unit of
measurement, source, and associated topics.

``` r
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
```

You can also get the list of supported indicators in a different
language. For example, to retrieve the indicators in Spanish:

``` r
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
```

To get the list of languages supported by the API, call:

``` r
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

Note that not all indicators and their columns might be translated into
all languages.

## Listing Supported Entities

You can retrieve a list of all entities supported by the World Bank API
along with metadata such as region, administrative region, income level,
and lending type. Note that a entity might be a country or a aggregate,
hence the more general table name.

``` r
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
```

This information can also be requested in other languages. For example,
to view the supported entities in Chinese:

``` r
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

### Downloading Indicator Data

With `wbwdi`, you can download indicator data for multiple entities and
indicators in a single function call. The function returns a tidy data
frame with country, indicator, date, and value columns.

For example, to download GDP per capita and total population for Mexico,
Canada, and the United States:

``` r
wdi_get(
  entities = c("MEX", "CAN", "USA"),
  indicators = c("NY.GDP.PCAP.KD", "SP.POP.TOTL")
)
#> # A tibble: 390 × 4
#>    entity_id indicator_id    year  value
#>    <chr>     <chr>          <int>  <dbl>
#>  1 CAN       NY.GDP.PCAP.KD  1960 15432.
#>  2 MEX       NY.GDP.PCAP.KD  1960  4146.
#>  3 USA       NY.GDP.PCAP.KD  1960 18854.
#>  4 CAN       NY.GDP.PCAP.KD  1961 15606.
#>  5 MEX       NY.GDP.PCAP.KD  1961  4219.
#>  6 USA       NY.GDP.PCAP.KD  1961 19019.
#>  7 CAN       NY.GDP.PCAP.KD  1962 16456.
#>  8 MEX       NY.GDP.PCAP.KD  1962  4276.
#>  9 USA       NY.GDP.PCAP.KD  1962 19877.
#> 10 CAN       NY.GDP.PCAP.KD  1963 17008.
#> # ℹ 380 more rows
```

If you need the same indicators for all entities, you can pass `"all"`
as the `entities` parameter:

``` r
wdi_get(
  entities = "all",
  indicators = c("NY.GDP.PCAP.KD", "SP.POP.TOTL")
)
#> # A tibble: 34,580 × 4
#>    entity_id indicator_id    year value
#>    <chr>     <chr>          <int> <dbl>
#>  1 AFE       NY.GDP.PCAP.KD  1960 1172.
#>  2 AFW       NY.GDP.PCAP.KD  1960 1122.
#>  3 ARB       NY.GDP.PCAP.KD  1960   NA 
#>  4 CSS       NY.GDP.PCAP.KD  1960 4377.
#>  5 CEB       NY.GDP.PCAP.KD  1960   NA 
#>  6 EAR       NY.GDP.PCAP.KD  1960 1062.
#>  7 EAS       NY.GDP.PCAP.KD  1960 1146.
#>  8 EAP       NY.GDP.PCAP.KD  1960  325.
#>  9 TEA       NY.GDP.PCAP.KD  1960  330.
#> 10 EMU       NY.GDP.PCAP.KD  1960 9943.
#> # ℹ 34,570 more rows
```

If you want to retrieve the indicators in a wide format, you can use the
corresponding parameter.

``` r
wdi_get(
  entities = "USA",
  indicators = c("NY.GDP.PCAP.KD", "SP.POP.TOTL"),
  format = "wide"
)
#> # A tibble: 65 × 4
#>    entity_id  year NY.GDP.PCAP.KD SP.POP.TOTL
#>    <chr>     <int>          <dbl>       <dbl>
#>  1 USA        1960         18854.   180671000
#>  2 USA        1961         19019.   183691000
#>  3 USA        1962         19877.   186538000
#>  4 USA        1963         20447.   189242000
#>  5 USA        1964         21327.   191889000
#>  6 USA        1965         22431.   194303000
#>  7 USA        1966         23635.   196560000
#>  8 USA        1967         24021.   198712000
#>  9 USA        1968         24951.   200706000
#> 10 USA        1969         25480.   202677000
#> # ℹ 55 more rows
```

## Other Helper Functions

You can fetch a list of all supported regions, sources, topics and
lending types, respectively, using the corresponding helper function:

``` r
wdi_get_regions()
wdi_get_sources()
wdi_get_topics()
wdi_get_lending_types()
```

If you want to search for specific keywords among indicators or other
data sources, you can use the built-in RStudio data frame viewing
functionality or the [Positron Data
Explorer](https://positron.posit.co/data-explorer.html). Alternatively,
this package comes with a helper function:

``` r
indicators <- wdi_get_indicators()
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
```

## Conclusion

The `wbwdi` package is designed to simplify the process of accessing and
analyzing World Bank data and combining it with other data sources. By
offering features like multi-indicator downloads, progress bars, and
flexible language support, `wbwdi` is a robust tool for users who need
access to World Development Indicators in a tidy format.

If you encounter any errors or have suggestions for improvements, please
consider opening an issue in the package repository on
[GitHub](https://github.com/tidy-intelligence/r-wbwdi/issues).
