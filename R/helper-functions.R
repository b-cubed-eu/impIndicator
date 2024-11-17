

#' Species by site
#'
#' @description
#' Compute species by site from an occurrence cube
#'
#'
#' @param cube The list containing data cube of class `sim_cube` from
#' `b3gbi::process_cube()`.
#' @param y The year to compute it species by site
#'
#' @return A data frame of specie by site. The row represent the site and column
#' represent the species

#'
#' @examples
species_by_site <- function(cube,y){
  sbs<-cube$data %>%
    dplyr::filter(year==y) %>%
    dplyr::select(scientificName,cellCode,obs) %>%
    #remove duplicates of a species per site
    dplyr::distinct(scientificName,cellCode, .keep_all = TRUE) %>%
    tidyr::pivot_wider(names_from = scientificName, values_from = obs) %>%
    dplyr::arrange(cellCode) %>%
    tibble::column_to_rownames(var = "cellCode")
  return(sbs)
}
