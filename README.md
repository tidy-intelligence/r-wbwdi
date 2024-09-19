
<!-- README.md is generated from README.Rmd. Please edit that file -->

The goal of ‘wdi2’ is to provide a modern, flexible interface for
accessing the World Bank’s World Development Indicators (WDI). Similar
to the ‘WDI’ package, ‘wdi2’ allows users to download, process, and
analyze indicator data for multiple countries and years. However, ‘wdi2’
differs by relying on ‘httr2’ for multi-page request and error handling,
using progress bars to keep users informed about the data
processing, and returning the processed data in a tidy data format.

## Installation

You can install the released version of `wdi2` from CRAN via:

``` r
install.packages("wdi2")
```

You can install the development version of wdi2 like so:

``` r
pak::pak("tidy-intelligence/r-wdi2")
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
