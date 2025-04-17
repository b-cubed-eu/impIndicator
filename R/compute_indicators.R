

#' Compute impact indicator
#'
#' @param data A dataframe containing species occurrences and
#' their aggregated impact score (from`impact_cat()`). Must be of the
#' form $data slot of `processed_cube` or `sim_cube`).
#' @param col Column on which `fun` is used.
#' @param fun Method to aggregate impact accross species in each site.
#' Can be `max`, `sum` or `mean`.
#' @importFrom rlang .data
#' @return A dataframe containing the value of impact score for each year
#' @noRd

compute_impact_indicator <- function(data,col,fun) {
  # avoid "no visible binding for global variable" NOTE for the following names
  cellCode <-  taxonKey <- year <- NULL

  data %>%
    # keep only one occurrence of a species at each site per year
    dplyr::distinct(taxonKey, year, cellCode, .keep_all = TRUE) %>%
    dplyr::group_by(year, cellCode) %>%
    dplyr::summarise(dplyr::across(dplyr::all_of(col), fun), .groups = "drop") %>%
    dplyr::group_by(year) %>%
    dplyr::summarise(dplyr::across(dplyr::all_of(col), sum), .groups = "drop") %>%
    dplyr::mutate(diversity_val = .data[[col]] / length(unique(data$cellCode)),
                  .keep = "unused")
}


#' Compute site impact indicator

#' @param data A dataframe containing species occurrences and
#' their aggregated impact score (from`impact_cat()`). Must be of the
#' form $data slot of `processed_cube` or `sim_cube`.
#' @param col Column on which `fun` is used.
#' @param fun Method to aggregate impact accross species in each site.
#' Can be `max`, `sum` or `mean`.
#' @return A dataframe containing the value of impact score per site
#' for each year in data
#' @noRd
compute_site_impact <- function(data, col, fun) {
  # avoid "no visible binding for global variable" NOTE for the following names
  cellCode <- xcoord <- ycoord <-  taxonKey <- year <- NULL

  data %>%
    dplyr::distinct(taxonKey, year, cellCode, .keep_all = TRUE) %>%
    dplyr::group_by(year, cellCode, xcoord, ycoord) %>%
    dplyr::summarise(dplyr::across(dplyr::all_of(col), fun), .groups = "drop") %>%
    tidyr::pivot_wider(names_from = year, values_from = dplyr::all_of(col))
}


#' compute species impact
#'
#'
#' @param data A dataframe containing species occurrences and
#' their aggregated impact score (from`impact_cat()`). Must be of the
#' form $data slot of `processed_cube` or `sim_cube`.
#' @param col Method of aggregation of within species impact
#' @importFrom rlang .data
#' @return A dataframe containing the impact indicator per species
#' @noRd
compute_species_impact<-function(data, col){
  # avoid "no visible binding for global variable" NOTE for the following names
  cellCode <-  taxonKey <- year <- scientificName <- NULL
  data %>%
    # keep only one occurrence of a species at each site per year
    dplyr::distinct(taxonKey,year,cellCode,.keep_all = TRUE) %>%
    dplyr::group_by(year,scientificName) %>%
    dplyr::summarise(dplyr::across(dplyr::all_of(col),sum),.groups = "drop") %>%
    dplyr::mutate(col = .data[[col]]/length(unique(data$cellCode)),
                  .keep="unused") %>%
    dplyr::arrange(scientificName) %>%
    tidyr::pivot_wider(names_from = scientificName, values_from = col) %>%
    dplyr::arrange(year)
}
