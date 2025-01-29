#' Maximum species impact
#'
#' Compute species impact using species maximum impact
#'
#' @param data A dataframe containing species occurrences and
#' their aggregated impact score (from`impact_cat()`). Must be of the
#' form $data slot of `processed_cube` or `sim_cube`.
#'
#' @return A dataframe containing the value of species impact for each year
#' @noRd
max_species_impact<-function(data){
  data %>%
    # keep only one occurrence of a species at each site per year
    dplyr::distinct(taxonKey,year,cellCode,.keep_all = TRUE) %>%
    dplyr::group_by(year,scientificName) %>%
    dplyr::summarise(dplyr::across(max,sum),.groups = "drop") %>%
    dplyr::mutate(max = max/length(unique(data$cellCode))) %>%
    dplyr::arrange(scientificName) %>%
    tidyr::pivot_wider(names_from = scientificName, values_from = max) %>%
    dplyr::arrange(year) %>%
    tibble::column_to_rownames(var="year")
}

#' Mean species impact
#'
#' Compute species impact using species mean impact
#'
#' @param data A dataframe containing species occurrences and
#' their aggregated impact score (from`impact_cat()`). Must be of the
#' form $data slot of `processed_cube` or `sim_cube`.
#'
#' @return A dataframe containing the value of species impact for each year
#' @noRd
mean_species_impact<-function(data){
  data %>%
    # keep only one occurrence of a species at each site per year
    dplyr::distinct(taxonKey,year,cellCode,.keep_all = TRUE) %>%
    dplyr::group_by(year,scientificName) %>%
    dplyr::summarise(dplyr::across(mean,sum),.groups = "drop") %>%
    dplyr::mutate(mean = mean/length(unique(data$cellCode))) %>%
    dplyr::arrange(scientificName) %>%
    tidyr::pivot_wider(names_from = scientificName, values_from = mean) %>%
    dplyr::arrange(year) %>%
    tibble::column_to_rownames(var="year")

}

#' Maximum per mechanism species impact
#'
#' Compute species impact using  the species sum of maximum per mechanism impact
#'
#' @param data A dataframe containing species occurrences and
#' their aggregated impact score (from`impact_cat()`). Must be of the
#' form $data slot of `processed_cube` or `sim_cube`.
#'
#' @return A dataframe containing the value of species impact for each year
#' @noRd
max_mech_species_impact<-function(data){
  data %>%
    # keep only one occurrence of a species at each site per year
    dplyr::distinct(taxonKey,year,cellCode,.keep_all = TRUE) %>%
    dplyr::group_by(year,scientificName) %>%
    dplyr::summarise(dplyr::across(max_mech,sum),.groups = "drop") %>%
    dplyr::mutate(max_mech = max_mech/length(unique(data$cellCode))) %>%
    dplyr::arrange(scientificName) %>%
    tidyr::pivot_wider(names_from = scientificName, values_from = max_mech) %>%
    dplyr::arrange(year) %>%
    tibble::column_to_rownames(var="year")
}
