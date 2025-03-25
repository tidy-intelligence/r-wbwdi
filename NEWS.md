# wbwdi 1.0.1

## Minor improvements and bug fixes

- Added `rlang::%||%` to imports because of failed CRAN checks for r-oldrel.
- Moved article dependencies to Config/Needs/website.
- Re-built README with outputs.

# wbwdi 1.0.0

## Major changes

- Changed wording in functions and parameters from "geography"" to "entity"" in compliance with the upcoming `econid` release.

# wbwdi 0.2.1

## Minor improvements and bug fixes

- Enhanced the `wdi_get()` function to support monthly and quarterly frequencies for specific indicators, allowing for more granular data analysis.
- Ensured a consistent interface with the `wbids` package, enabling seamless integration when working with both World Development Indicators and International Debt Statistics.
- Addressed problems with API requests to ensure reliable data fetching and handling of responses.
- Provided detailed examples and use cases in the package vignettes to guide users in effectively utilizing the package's features.
- Improved function documentation to clearly explain parameters, return values, and usage examples.
- Added `most_recent_only` parameter to `wdi_get()` to support the upcoming `econtools` package.

# wbwdi 0.1.0

- Initial release that includes the functions `wdi_get()`, `wdi_get_topics()`, `wdi_get_sources()`, `wdi_get_regions()`, `wdi_get_lending_types()`, `wdi_get_languages()`, `wdi_get_indicators()`, `wdi_get_income_levels()`, `wdi_get_geographies()`
