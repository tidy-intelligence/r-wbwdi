
<!-- README.md is generated from README.Rmd. Please edit that file -->

The goal of ‘wbwdi’ is to provide a modern, flexible interface for
accessing the World Bank’s World Development Indicators (WDI). ‘wbwdi’
allows users to download, process, and analyze indicator data for
multiple countries and time periods. ‘wbwdi’ relies on ‘httr2’ for
multi-page request and error handling and using progress bars to keep
users informed about the data processing.

This package is in development status. Please consider using one of the
packages on CRAN:

- [WDI](https://cran.r-project.org/web/packages/WDI/index.html)
- [worldbank](https://cran.r-project.org/web/packages/worldbank/index.html)
- [wbstats](https://cran.r-project.org/web/packages/wbstats/index.html)

## Installation

You can install the development version of ‘wbwdi’ like so:

``` r
pak::pak("tidy-intelligence/r-wbwdi")
```

## Usage

You can get a list of all indicators supported by the WDI API via:

``` r
list_supported_indicators()
```

You can get a list of all supported countries via:

``` r
list_supported_countries()
```

You can also get the list of supported indicators and countries in
another language, but note that not everything seems to be translated
into other languages:

``` r
list_supported_indicators(language = "es")
list_supported_countries(language = "zh")
```

Check out the following function for a list of supported languages:

``` r
list_supported_languages()
```

You can download specific indicators for a selection of countries via:

``` r
download_indicators(countries = c("MX", "CA", "US"), indicators = c("NY.GDP.PCAP.KD", "SP.POP.TOTL"))
```

You can also download these indicators for all countries:

``` r
download_indicators(countries = "all", indicators = c("NY.GDP.PCAP.KD", "SP.POP.TOTL"))
```

List all supported languages via:

``` r
list_supported_languages()
```

List supported regions, sources, topics and lending types, respectively:

``` r
list_supported_regions()
list_supported_sources()
list_supported_topics()
list_supported_lending_types()
```
