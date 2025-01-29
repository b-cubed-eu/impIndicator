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
#' @noRd
# species_by_site <- function(cube, y) {
#   # avoid "no visible binding for global variable" NOTE for the following names
#   year <- scientificName <- cellCode <- obs <- NULL
#   sbs <- cube$data %>%
#     dplyr::filter(year == y) %>%
#     dplyr::mutate(obs=1) %>%
#     dplyr::select(scientificName, cellCode, obs) %>%
#     # remove duplicates of a species per site
#     dplyr::distinct(scientificName, cellCode, .keep_all = TRUE) %>%
#     tidyr::pivot_wider(names_from = scientificName, values_from = obs) %>%
#     dplyr::arrange(cellCode) %>%
#     tibble::column_to_rownames(var = "cellCode")
#   return(sbs)
# }


#' EICAT category to numeric
#'
#' @description
#' Convert EICAT categories to numerical values
#'
#' @param cat The EICAT impct category. (e.g., "MC)
#' @param trans Numeric. The type of transformation to convert the EICAT categories to
#' numerical values. 1 converts ("MC", "MN", "MO", "MR", "MV") to (0,1,2,3,4)
#' 2 converts ("MC", "MN", "MO", "MR", "MV") to (1,2,3,4,5) and
#' 3 converts ("MC", "MN", "MO", "MR", "MV") to (1,10,100,1000,10000)
#'
#' @return Numerical values corresponding to the EICAT  base on a tranfomation
#' @noRd

cat_num <- function(cat, trans) {
  name <- c("MC", "MN", "MO", "MR", "MV")
  if (trans == 1) {
    x <- c(0, 1, 2, 3, 4)
    names(x) <- name
  } else if (trans == 2) {
    x <- c(1, 2, 3, 4, 5)
    names(x) <- name
  } else { # else if trans = 3
    x <- c(0, 1, 10, 100, 1000, 10000)
    names(x) <- name
  }
  return(x[cat])
}
