#' Precautionary cumulative
#'
#' Compute impact indicator based on precautionary cumulative method
#'
#' @param impact_cube_data
#'
#' @return
#' @export
#'
#' @examples
prec_indicator<-function(impact_cube_data){
  impact_cube_data %>%
    # keep only one occurrence of a species at each site per year
    dplyr::distinct(taxonKey, year, cellCode, .keep_all = TRUE) %>%
    dplyr::group_by(year, cellCode) %>%
    dplyr::summarise(dplyr::across(max, max), .groups = "drop") %>%
    dplyr::group_by(year) %>%
    dplyr::summarise(dplyr::across(max, sum), .groups = "drop") %>%
    dplyr::mutate(max = max / cube$num_cells) %>%
    dplyr::rename(value = "max")
}

#' Title
#'
#' @param impact_cube_data
#'
#' @return
#' @export
#'
#' @examples
prec_cum_indicator<-function(impact_cube_data){
  impact_cube_data %>%
    # keep only one occurrence of a species at each site per year
    dplyr::distinct(taxonKey, year, cellCode, .keep_all = TRUE) %>%
    dplyr::group_by(year, cellCode) %>%
    dplyr::summarise(dplyr::across(max, sum), .groups = "drop") %>%
    dplyr::group_by(year) %>%
    dplyr::summarise(dplyr::across(max, sum), .groups = "drop") %>%
    dplyr::mutate(max = max / cube$num_cells) %>%
    dplyr::rename(value = "max")
}


mean_indicator<-function(impact_cube_data){
  impact_cube_data %>%
    # keep only one occurrence of a species at each site per year
    dplyr::distinct(taxonKey, year, cellCode, .keep_all = TRUE) %>%
    dplyr::group_by(year, cellCode) %>%
    dplyr::summarise(dplyr::across(mean, mean), .groups = "drop") %>%
    dplyr::group_by(year) %>%
    dplyr::summarise(dplyr::across(mean, sum), .groups = "drop") %>%
    dplyr::mutate(mean = mean / cube$num_cells) %>%
    dplyr::rename(value = "mean")
}

mean_cum_indicator<-function(impact_cube_data){
  impact_cube_data %>%
    # keep only one occurrence of a species at each site per year
    dplyr::distinct(taxonKey, year, cellCode, .keep_all = TRUE) %>%
    dplyr::group_by(year, cellCode) %>%
    dplyr::summarise(dplyr::across(mean, sum), .groups = "drop") %>%
    dplyr::group_by(year) %>%
    dplyr::summarise(dplyr::across(mean, sum), .groups = "drop") %>%
    dplyr::mutate(mean = mean / cube$num_cells) %>%
    dplyr::rename(value = "mean")
}

cum_indicatator<-function(impact_cube_data){
  impact_cube_data %>%
    # keep only one occurrence of a species at each site per year
    dplyr::distinct(taxonKey, year, cellCode, .keep_all = TRUE) %>%
    dplyr::group_by(year, cellCode) %>%
    dplyr::summarise(dplyr::across(max_mech, sum), .groups = "drop") %>%
    dplyr::group_by(year) %>%
    dplyr::summarise(dplyr::across(max_mech, sum), .groups = "drop") %>%
    dplyr::mutate(max_mech = max_mech / cube$num_cells) %>%
    dplyr::rename(value = "max_mech")
}
