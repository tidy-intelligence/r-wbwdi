wbwdi
================

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/wbwdi)](https://cran.r-project.org/package=wbwdi)
[![CRAN
downloads](https://cranlogs.r-pkg.org/badges/wbwdi)](https://cran.r-project.org/package=wbwdi)
![R CMD
Check](https://github.com/tidy-intelligence/r-wbwdi/actions/workflows/R-CMD-check.yaml/badge.svg)
![Lint](https://github.com/tidy-intelligence/r-wbwdi/actions/workflows/lint.yaml/badge.svg)
[![Codecov test
coverage](https://codecov.io/gh/tidy-intelligence/r-wbwdi/graph/badge.svg)](https://app.codecov.io/gh/tidy-intelligence/r-wbwdi)
[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

<!-- README.md is generated from README.Rmd. Please edit that file -->

`wbwdi` is an R package to access and analyze the World Bank’s World
Development Indicators (WDI) using the corresponding
[API](https://datahelpdesk.worldbank.org/knowledgebase/articles/889392-about-the-indicators-api-documentation).
WDI provides more than 24,000 country or region-level indicators for
various contexts. `wbwdi` enables users to download, process and work
with WDI series across multiple entities and time periods.

The package is designed to work seamlessly with International Debt
Statistics (IDS) provided through the
[`wbids`](https://github.com/Teal-Insights/r-wbids) package and shares
its syntax with its sibling Python library
[`wbwdi`](https://github.com/tidy-intelligence/py-wbwdi). It follows the
principles of the [econdataverse](https://www.econdataverse.org/).

This package is a product of Christoph Scheuch and not sponsored by or
affiliated with the World Bank in any way, except for the use of the
World Bank WDI API.

## Installation

You can install `wbwdi` from CRAN via:

``` r
install.packages("wbwdi")
```

You can install the development version of `wbwdi` like this:

``` r
pak::pak("tidy-intelligence/r-wbwdi")
```

## Usage

The main function `wdi_get()` provides an interface to download multiple
WDI series for multiple entities and specific date ranges.

``` r
library(wbwdi)

wdi_get(
  entities = c("MEX", "CAN", "USA"), 
  indicators = c("NY.GDP.PCAP.KD", "SP.POP.TOTL"),
  start_year = 2020, 
  end_year = 2024
)
#> # A tibble: 24 × 4
#>    entity_id indicator_id    year  value
#>    <chr>     <chr>          <int>  <dbl>
#>  1 CAN       NY.GDP.PCAP.KD  2020 42366.
#>  2 MEX       NY.GDP.PCAP.KD  2020  9235.
#>  3 USA       NY.GDP.PCAP.KD  2020 59493.
#>  4 CAN       NY.GDP.PCAP.KD  2021 44360.
#>  5 MEX       NY.GDP.PCAP.KD  2021  9728.
#>  6 USA       NY.GDP.PCAP.KD  2021 62996.
#>  7 CAN       NY.GDP.PCAP.KD  2022 45227.
#>  8 MEX       NY.GDP.PCAP.KD  2022 10011.
#>  9 USA       NY.GDP.PCAP.KD  2022 64342.
#> 10 CAN       NY.GDP.PCAP.KD  2023 44469.
#> # ℹ 14 more rows
```

You can also download these indicators for all entities and available
dates:

``` r
wdi_get(
  entities = "all", 
  indicators = c("NY.GDP.PCAP.KD", "SP.POP.TOTL")
)
#> # A tibble: 34,048 × 4
#>    entity_id indicator_id    year value
#>    <chr>     <chr>          <int> <dbl>
#>  1 AFE       NY.GDP.PCAP.KD  1960 1172.
#>  2 AFW       NY.GDP.PCAP.KD  1960 1111.
#>  3 ARB       NY.GDP.PCAP.KD  1960   NA 
#>  4 CSS       NY.GDP.PCAP.KD  1960 4422.
#>  5 CEB       NY.GDP.PCAP.KD  1960   NA 
#>  6 EAR       NY.GDP.PCAP.KD  1960 1062.
#>  7 EAS       NY.GDP.PCAP.KD  1960 1144.
#>  8 EAP       NY.GDP.PCAP.KD  1960  323.
#>  9 TEA       NY.GDP.PCAP.KD  1960  327.
#> 10 EMU       NY.GDP.PCAP.KD  1960 9943.
#> # ℹ 34,038 more rows
```

Some indicators are also available on a monthly basis, e.g.:

``` r
wdi_get(
  entities = "AUT", 
  indicators = "DPANUSSPB",         
  start_year = 2012, 
  end_year = 2015, 
  frequency = "month"
)
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
```

Similarly, there are also some indicators available on a quarterly
frequency, e.g.:

``` r
wdi_get(
  entities = "NGA", 
  indicators =  "DT.DOD.DECT.CD.TL.US",
  start_year = 2012, 
  end_year = 2015, 
  frequency = "quarter"
)
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
```

You can get a list of all indicators supported by the WDI API via:

``` r
wdi_get_indicators()
#> # A tibble: 22,806 × 7
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
#> # ℹ 22,796 more rows
#> # ℹ 2 more variables: source_organization <chr>, topics <list>
```

You can get a list of all supported entities via:

``` r
wdi_get_entities()
#> # A tibble: 296 × 19
#>    entity_id entity_iso2code entity_type capital_city     entity_name  region_id
#>    <chr>     <chr>           <chr>       <chr>            <chr>        <chr>    
#>  1 ABW       AW              country     Oranjestad       Aruba        LCN      
#>  2 AFE       ZH              aggregates  <NA>             Africa East… NA       
#>  3 AFG       AF              country     Kabul            Afghanistan  SAS      
#>  4 AFR       A9              aggregates  <NA>             Africa       NA       
#>  5 AFW       ZI              aggregates  <NA>             Africa West… NA       
#>  6 AGO       AO              country     Luanda           Angola       SSF      
#>  7 ALB       AL              country     Tirane           Albania      ECS      
#>  8 AND       AD              country     Andorra la Vella Andorra      ECS      
#>  9 ARB       1A              aggregates  <NA>             Arab World   NA       
#> 10 ARE       AE              country     Abu Dhabi        United Arab… MEA      
#> # ℹ 286 more rows
#> # ℹ 13 more variables: region_iso2code <chr>, region_name <chr>,
#> #   admin_region_id <chr>, admin_region_iso2code <chr>,
#> #   admin_region_name <chr>, income_level_id <chr>,
#> #   income_level_iso2code <chr>, income_level_name <chr>,
#> #   lending_type_id <chr>, lending_type_iso2code <chr>,
#> #   lending_type_name <chr>, longitude <dbl>, latitude <dbl>
```

You can also get the list of supported indicators and entities in
another language, but note that not everything seems to be translated
into other languages:

``` r
wdi_get_indicators(language = "es")
wdi_get_entities(language = "zh")
```

Check out the following function for a list of supported languages:

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

In addition, you can list supported regions, sources, topics and lending
types, respectively:

``` r
wdi_get_regions()
wdi_get_sources()
wdi_get_topics()
wdi_get_lending_types()
```

If you want to search for specific keywords among indicators or other
data sources, you can use the RStudio or Positron data explorer.
Alternatively, this package comes with a helper function:

``` r
indicators <- wdi_get_indicators()
wdi_search(
  indicators,
  keywords = c("inequality", "gender"),
  columns = c("indicator_name")
)
#> # A tibble: 157 × 7
#>    indicator_id         indicator_name         source_id source_name source_note
#>    <chr>                <chr>                      <int> <chr>       <chr>      
#>  1 2.3_GIR.GPI          "Gender parity index …        34 Global Par… "Ratio of …
#>  2 2.6_PCR.GPI          "Gender parity index …        34 Global Par… "Ratio of …
#>  3 BI.EMP.PWRK.PB.FE.ZS "Public sector employ…        64 Worldwide …  <NA>      
#>  4 BI.EMP.PWRK.PB.MA.ZS "Public sector employ…        64 Worldwide …  <NA>      
#>  5 BI.EMP.TOTL.PB.FE.ZS "Public sector employ…        64 Worldwide …  <NA>      
#>  6 BI.EMP.TOTL.PB.MA.ZS "Public sector employ…        64 Worldwide …  <NA>      
#>  7 BI.WAG.PREM.PB.FE    "Public sector wage p…        64 Worldwide …  <NA>      
#>  8 BI.WAG.PREM.PB.FM    "P-Value: Public sect…        64 Worldwide …  <NA>      
#>  9 BI.WAG.PREM.PB.FM.CA "P-Value: Gender wage…        64 Worldwide …  <NA>      
#> 10 BI.WAG.PREM.PB.FM.ED "P-Value: Gender wage…        64 Worldwide …  <NA>      
#> # ℹ 147 more rows
#> # ℹ 2 more variables: source_organization <chr>, topics <list>
```

## Relation to Existing R Packages

The most important differences to existing packages are that `wbwdi` is
designed to (i) have a narrow focus on World Bank Development
Indicators, (ii) have a consistent interface with other R packages
(e.g., [`wbids`](https://github.com/Teal-Insights/r-wbids)), (iii) have
an MIT license, and (iv) have a shared interface with Python libraries
(e.g., [`wbwdi`](https://github.com/tidy-intelligence/py-wbwdi)).
`wbwdi` also refrains from using cached data because this approach
frequently leads to problems for users due to outdated caches and it
uses `httr2` to manage API requests and parse responses.

More specifically, the differences of existing CRAN releases (apart from
interface design) are:

- [`WDI`](https://CRAN.R-project.org/package=WDI): uses cached data by
  default, does not allow downloading meta data from the WDI API (e.g.,
  languages, sources, topics), has a GPL-3 license, and does neither use
  `httr` nor `httr2` for requests.
- [`worldbank`](https://CRAN.R-project.org/package=worldbank): does not
  have a narrow focus because it includes the Poverty and Inequality
  Platform and Finances One API.
- [`wbstats`](https://CRAN.R-project.org/package=wbstats): uses cached
  data by default, does not use `httr2`.
