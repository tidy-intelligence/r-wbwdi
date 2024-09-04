
# wdi2

The goal of wdi2 is to provide a modern, flexible interface for accessing the World Bank’s World Development Indicators (WDI). Similar to the 'WDI' package, 'wdi2' allows users to download, process, and analyze indicator data for multiple countries and years. However, 'wdi2' differs by relying on 'httr2' for multi-page request and error handling and providing the processed data in a tidy format.

## Installation

You can install the development version of wdi2 like so:

``` r
pak::pak("tidy-intelligence/r-wdi2")
```

## Usage

You can download a data frame with available indicators via:

```r
download_indicators()
```

You can download a data frame with available countries via:

```r
download_countries()
```

You can download single indicators via:

```r
download_indicator("all", "NY.GDP.PCAP.KD")
```
