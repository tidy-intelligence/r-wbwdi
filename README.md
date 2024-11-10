wbwdi
================

<!-- badges: start --> ![R CMD
Check](https://github.com/tidy-intelligence/r-wbwdi/actions/workflows/R-CMD-check.yaml/badge.svg)
![Lint](https://github.com/tidy-intelligence/r-wbwdi/actions/workflows/lint.yaml/badge.svg)
[![Codecov test
coverage](https://codecov.io/gh/tidy-intelligence/r-wbwdi/graph/badge.svg)](https://app.codecov.io/gh/tidy-intelligence/r-wbwdi)
<!-- badges: end -->

<!-- README.md is generated from README.Rmd. Please edit that file -->

The goal of ‘wbwdi’ is to provide a modern, flexible interface for
accessing the World Bank’s [World Development Indicators (WDI)
API](https://datahelpdesk.worldbank.org/knowledgebase/articles/889392-about-the-indicators-api-documentation)
through R. ‘wbwdi’ allows users to download, process, and analyze WDI
indicators for multiple geographies and specific time periods. The
package is designed to work seamlessly with International Debt
Statistics (IDS) provided through the ‘wbids’ package and the Python
library [‘wbwdi’](https://github.com/tidy-intelligence/py-wbwdi).

This package is a product of Christoph Scheuch and not sponsored by or
affiliated with the World Bank in any way, except for the use of the
World Bank WDI API.

## Installation

You can install the development version of ‘wbwdi’ like this:

``` r
pak::pak("tidy-intelligence/r-wbwdi")
```

## Usage

The main function `wdi_get()` provides an interface to download multiple
WDI series for multiple geographies and specific date ranges.

``` r
wdi_get(
  geographies = c("MX", "CA", "US"), 
  indicators = c("NY.GDP.PCAP.KD", "SP.POP.TOTL"),
  start_date = 2020, end_date = 2024
)
```

You can also download these indicators for all geographies and available
dates:

``` r
wdi_get(
  geographies = "all", 
  indicators = c("NY.GDP.PCAP.KD", "SP.POP.TOTL")
)
```

You can get a list of all indicators supported by the WDI API via:

``` r
wdi_get_indicators()
```

You can get a list of all supported geographies via:

``` r
wdi_get_geographies()
```

You can also get the list of supported indicators and geographies in
another language, but note that not everything seems to be translated
into other languages:

``` r
wdi_get_indicators(language = "es")
wdi_get_geographies(language = "zh")
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

## Relation to existing packages

The most important difference to existing packages is that ‘wbwdi’ is
designed to (i) have a narrow focus on World Bank Development
Indicators, (ii) have a consistent interface with other R packages
(e.g., ‘wbids’), and (iii) have a shared interface with Python libraries
(e.g. [‘py-wbwdi’](https://github.com/tidy-intelligence/py-wbwdi)).
‘wbwdi’ also refrains from using cached data because this approach
frequently leads to problems for users to to outdated caches and uses
‘httr2’ to manage API requests.

The relation to the most popular existing R packages are:

- [WDI](https://cran.r-project.org/web/packages/WDI/index.html): uses
  cached data by default, does not allow downloading meta data from the
  WDI API (e.g., languages, sources, topics), does neither use ‘httr’
  nor ‘httr2’.
- [worldbank](https://cran.r-project.org/web/packages/worldbank/index.html):
  does not have a narrow focus because it includes the Poverty and
  Inequality Platform and Finances One API.
- [wbstats](https://cran.r-project.org/web/packages/wbstats/index.html):
  uses cached data by default, does not use ‘httr2’.
