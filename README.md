
<!-- README.md is generated from README.Rmd. Please edit that file -->

The goal of ‘wbwdi’ is to provide a modern, flexible interface for
accessing the World Bank’s [World Development Indicators (WDI)
API](https://datahelpdesk.worldbank.org/knowledgebase/articles/889392-about-the-indicators-api-documentation).
‘wbwdi’ allows users to download, process, and analyze WDI indicators
for multiple geographies and specific time periods. The package is
designed to work seamlessly with International Debt Statistics (IDS)
provided through the ‘wbids’ package.

This package is in development status. Please consider using one of the
packages on CRAN:

- [WDI](https://cran.r-project.org/web/packages/WDI/index.html)
- [worldbank](https://cran.r-project.org/web/packages/worldbank/index.html)
- [wbstats](https://cran.r-project.org/web/packages/wbstats/index.html)

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

In additiona, you can list supported regions, sources, topics and
lending types, respectively:

``` r
wdi_get_regions()
wdi_get_sources()
wdi_get_topics()
wdi_get_lending_types()
```
