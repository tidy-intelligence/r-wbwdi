#' Download and process country data from the World Bank API
#'
#' This function retrieves a comprehensive list of country data from the World Bank API.
#' The data is processed to extract and organize relevant fields, including region,
#' administrative region, income level, lending type, and other country information.
#'
#' The data is returned as a tidy dataframe, where specific attributes such as region,
#' administrative region, income level, and lending type are nested within the dataframe.
#'
#' @return A tibble containing processed country information. The following columns are included:
#' \describe{
#'   \item{iso2_code}{ISO 3166-1 alpha-2 country code.}
#'   \item{capital_city}{The capital city of the country.}
#'   \item{regions}{A nested tibble with region information.}
#'   \item{admin_regions}{A nested tibble with administrative region information.}
#'   \item{income_levels}{A nested tibble with income level information.}
#'   \item{lending_types}{A nested tibble with lending type information.}
#' }
#'
#' @details The data is fetched in JSON format from the World Bank API and is processed
#' to replace any empty strings with `NA` values. The function ensures the data
#' is in a tidy format, and it returns the relevant country details.
#'
#' @export
#'
#' @examples
#' download_countries()
#'
download_countries <- function() {
  url <- "https://api.worldbank.org/v2/countries/all?per_page=25000&format=json"

  responses <- request(url) |>
    req_perform()

  body <- responses |>
    resp_body_json()

  check_for_failed_request(body)

  countries_raw <- body[[2]] |>
    bind_rows()

  countries_processed <- countries_raw|>
    tidyr::unnest(c(region, adminregion, incomeLevel, lendingType)) |>
    mutate(across(where(is.character), ~ if_else(.x == "", NA, .x))) |>
    rename(iso2_code = iso2Code,
           admin_region = adminregion,
           income_level = incomeLevel,
           lending_type = lendingType,
           capital_city = capitalCity) |>
    tidyr::nest(regions = region,
                admin_regions = admin_region,
                income_levels = income_level,
                lending_types = lending_type)

  countries_processed
}
