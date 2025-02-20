#' Precautionary site impact
#'
#' Compute site impact based on the precautionary method
#'
#' @param data A dataframe containing species occurrences and
#' their aggregated impact score (from`impact_cat()`). Must be of the
#' form $data slot of `processed_cube` or `sim_cube`.
#'
#' @return A dataframe containing the value of impact of each site for each year
#' @noRd
prec_site_impact<-function(data){
  # avoid "no visible binding for global variable" NOTE for the following names
  cellCode <- xcoord <- ycoord <-  taxonKey <- year <- NULL

  data %>%
    dplyr::distinct(taxonKey, year, cellCode, .keep_all = TRUE) %>%
    dplyr::group_by(year, cellCode, xcoord, ycoord) %>%
    dplyr::summarise(dplyr::across(max, max), .groups = "drop") %>%
    tidyr::pivot_wider(names_from = year, values_from = max)
}

#' Precautionary cumulative site impact
#'
#' Compute site impact based on the precautionary cumulative method
#'
#' @param data A dataframe containing species occurrences and
#' their aggregated impact score (from`impact_cat()`). Must be of the
#' form $data slot of `processed_cube` or `sim_cube`.
#'
#' @return A dataframe containing the value of impact of each site for each year
#' @noRd
prec_cum_site_impact<-function(data){

  # avoid "no visible binding for global variable" NOTE for the following names
  cellCode <- xcoord <- ycoord <-  taxonKey <- year <- NULL

  data %>%
    dplyr::distinct(taxonKey, year, cellCode, .keep_all = TRUE) %>%
    dplyr::group_by(year, cellCode, xcoord, ycoord) %>%
    dplyr::summarise(dplyr::across(max, sum), .groups = "drop") %>%
    tidyr::pivot_wider(names_from = year, values_from = max)
}

#' Mean site impact
#'
#' Compute site impact based on the mean method
#'
#' @param data A dataframe containing species occurrences and
#' their aggregated impact score (from`impact_cat()`). Must be of the
#' form $data slot of `processed_cube` or `sim_cube`.
#'
#' @return A dataframe containing the value of impact of each site for each year
#' @noRd
mean_site_impact<-function(data){
  # avoid "no visible binding for global variable" NOTE for the following names
  cellCode <- xcoord <- ycoord <-  taxonKey <- year <- NULL

  data %>%
    dplyr::distinct(taxonKey, year, cellCode, .keep_all = TRUE) %>%
    dplyr::group_by(year, cellCode, xcoord, ycoord) %>%
    dplyr::summarise(dplyr::across(mean, mean), .groups = "drop") %>%
    tidyr::pivot_wider(names_from = year, values_from = mean)
}

#' Mean cumulative site impact
#'
#' Compute site impact based on the mean cumulative method
#'
#' @param data A dataframe containing species occurrences and
#' their aggregated impact score (from`impact_cat()`). Must be of the
#' form $data slot of `processed_cube` or `sim_cube`.
#'
#' @return A dataframe containing the value of impact of each site for each year
#' @noRd
mean_cum_site_impact<-function(data){
  # avoid "no visible binding for global variable" NOTE for the following names
  cellCode <- xcoord <- ycoord <-  taxonKey <- year <- NULL

  data %>%
    dplyr::distinct(taxonKey, year, cellCode, .keep_all = TRUE) %>%
    dplyr::group_by(year, cellCode, xcoord, ycoord) %>%
    dplyr::summarise(dplyr::across(mean, sum), .groups = "drop") %>%
    tidyr::pivot_wider(names_from = year, values_from = mean)
}


#' Cumulative site impact
#'
#' Compute site impact based on the cumulative method
#'
#' @param data A dataframe containing species occurrences and
#' their aggregated impact score (from`impact_cat()`). Must be of the
#' form $data slot of `processed_cube` or `sim_cube`.
#'
#' @return A dataframe containing the value of impact of each site for each year
#' @noRd
cum_site_impact<-function(data){

  # avoid "no visible binding for global variable" NOTE for the following names
  cellCode <- xcoord <- ycoord <-  taxonKey <- year <- max_mech<- NULL
  data %>%
    dplyr::distinct(taxonKey, year, cellCode, .keep_all = TRUE) %>%
    dplyr::group_by(year, cellCode, xcoord, ycoord) %>%
    dplyr::summarise(dplyr::across(max_mech, sum), .groups = "drop") %>%
    tidyr::pivot_wider(names_from = year, values_from = max_mech)
}
