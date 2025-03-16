
#'
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
#' @param cat The EICAT impact category. (e.g., "MC")
#' @param trans Numeric: `1`, `2` or `3`. The method of transformation to
#' convert the EICAT categories `c("MC", "MN", "MO", "MR", "MV")` to numerical
#' values:
#'   - `1`: converts the categories to `c(0, 1, 2, 3, 4)`
#'   - `2`: converts the categories to to `c(1, 2, 3, 4, 5)`
#'   - `3`: converts the categories to to `c(1, 10, 100, 1000, 10000)`
#'
#' @return Numerical values corresponding to the EICAT  base on a transformation
#' @noRd

cat_num <- function(cat, trans) {
  name <- c("MC", "MN", "MO", "MR", "MV")
  if (trans == 1) {
    x <- 0:4
  } else if (trans == 2) {
    x <- 1:5
  } else { # else if trans = 3
    x <- c(0, 1, 10, 100, 1000, 10000)
  }
  names(x) <- name

  return(x[cat])
}
