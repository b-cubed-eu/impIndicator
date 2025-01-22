#' Precautionary indicator
#'
#' Compute impact indicator based on the precautionary method
#'
#' @param data A dataframe containing species occurrences and
#' their aggregated impact score (from`impact_cat()`). Must be of the
#' form $data slot of `processed_cube` or `sim_cube`).
#'
#' @return A dataframe containing the value of impact score for each year
#' @export
#' @noRd

prec_indicator <- function(data) {
  data %>%
    # keep only one occurrence of a species at each site per year
    dplyr::distinct(taxonKey, year, cellCode, .keep_all = TRUE) %>%
    dplyr::group_by(year, cellCode) %>%
    dplyr::summarise(dplyr::across(max, max), .groups = "drop") %>%
    dplyr::group_by(year) %>%
    dplyr::summarise(dplyr::across(max, sum), .groups = "drop") %>%
    dplyr::mutate(max = max / cube$num_cells) %>%
    dplyr::rename(value = "max")
}

#' Precautionary cumulative indicator
#'
#' Compute impact indicator based on the precautionary cumulative method
#'
#' @param data A dataframe containing species occurrences and
#' their aggregated impact score (from`impact_cat()`). Must be of the
#' form $data slot of `processed_cube` or `sim_cube`).
#'
#' @return A dataframe containing the value of impact score for each year
#' @noRd
#'

prec_cum_indicator <- function(data) {
  data %>%
    # keep only one occurrence of a species at each site per year
    dplyr::distinct(taxonKey, year, cellCode, .keep_all = TRUE) %>%
    dplyr::group_by(year, cellCode) %>%
    dplyr::summarise(dplyr::across(max, sum), .groups = "drop") %>%
    dplyr::group_by(year) %>%
    dplyr::summarise(dplyr::across(max, sum), .groups = "drop") %>%
    dplyr::mutate(max = max / cube$num_cells) %>%
    dplyr::rename(value = "max")
}

#' Mean indicator
#'
#' Compute impact indicator based on the mean method
#'
#' @param data A dataframe containing species occurrences and
#' their aggregated impact score (from`impact_cat()`). Must be of the
#' form $data slot of `processed_cube` or `sim_cube`).
#'
#' @return A dataframe containing the value of impact score for each year in data
#' @noRd
#'

mean_indicator <- function(data) {
  data %>%
    # keep only one occurrence of a species at each site per year
    dplyr::distinct(taxonKey, year, cellCode, .keep_all = TRUE) %>%
    dplyr::group_by(year, cellCode) %>%
    dplyr::summarise(dplyr::across(mean, mean), .groups = "drop") %>%
    dplyr::group_by(year) %>%
    dplyr::summarise(dplyr::across(mean, sum), .groups = "drop") %>%
    dplyr::mutate(mean = mean / cube$num_cells) %>%
    dplyr::rename(value = "mean")
}

#' Mean cumulative indicator
#'
#' Compute impact indicator based on the mean cumulative method
#'
#' @param data A dataframe containing species occurrences and
#' their aggregated impact score (from`impact_cat()`). Must be of the
#' form $data slot of `processed_cube` or `sim_cube`).
#'
#' @return A dataframe containing the value of impact score for each year in data
#' @noRd
#'

mean_cum_indicator <- function(data) {
  data %>%
    # keep only one occurrence of a species at each site per year
    dplyr::distinct(taxonKey, year, cellCode, .keep_all = TRUE) %>%
    dplyr::group_by(year, cellCode) %>%
    dplyr::summarise(dplyr::across(mean, sum), .groups = "drop") %>%
    dplyr::group_by(year) %>%
    dplyr::summarise(dplyr::across(mean, sum), .groups = "drop") %>%
    dplyr::mutate(mean = mean / cube$num_cells) %>%
    dplyr::rename(value = "mean")
}

#' Cumulative indicator
#'
#' Compute impact indicator based on the cumulative method
#'
#' @param data A dataframe containing species occurrences and
#' their aggregated impact score (from`impact_cat()`). Must be of the
#' form $data slot of `processed_cube` or `sim_cube`).
#'
#' @return A dataframe containing the value of impact score for each year in data
#' @noRd
#'

cum_indicatator <- function(data) {
  data %>%
    # keep only one occurrence of a species at each site per year
    dplyr::distinct(taxonKey, year, cellCode, .keep_all = TRUE) %>%
    dplyr::group_by(year, cellCode) %>%
    dplyr::summarise(dplyr::across(max_mech, sum), .groups = "drop") %>%
    dplyr::group_by(year) %>%
    dplyr::summarise(dplyr::across(max_mech, sum), .groups = "drop") %>%
    dplyr::mutate(max_mech = max_mech / cube$num_cells) %>%
    dplyr::rename(value = "max_mech")
}
