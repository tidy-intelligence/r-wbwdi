wbwdi
================

<!-- badges: start -->

![R CMD
Check](https://github.com/tidy-intelligence/r-wbwdi/actions/workflows/R-CMD-check.yaml/badge.svg)
![Lint](https://github.com/tidy-intelligence/r-wbwdi/actions/workflows/lint.yaml/badge.svg)
[![Codecov test
coverage](https://codecov.io/gh/tidy-intelligence/r-wbwdi/graph/badge.svg)](https://app.codecov.io/gh/tidy-intelligence/r-wbwdi)
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
wdi_get(
  entities = c("MX", "CA", "US"), 
  indicators = c("NY.GDP.PCAP.KD", "SP.POP.TOTL"),
  start_year = 2020, end_year = 2024
)
```

You can also download these indicators for all entities and available
dates:

``` r
wdi_get(
  entities = "all", 
  indicators = c("NY.GDP.PCAP.KD", "SP.POP.TOTL")
)
```

Some indicators are also available on a monthly basis, e.g.:

``` r
wdi_get(
  entities = "AUT", 
  indicators = "DPANUSSPB",         
  start_year = 2012, end_year = 2015, 
  frequency = "month"
)
```

Similarly, there are also some indicators available on a quarterly
frequency, e.g.:

``` r
wdi_get(
  entities = "NGA", 
  indicators =  "DT.DOD.DECT.CD.TL.US",
  start_year = 2012, end_year = 2015, 
  frequency = "quarter"
)
```

You can get a list of all indicators supported by the WDI API via:

``` r
wdi_get_indicators()
```

You can get a list of all supported entities via:

``` r
wdi_get_entities()
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
