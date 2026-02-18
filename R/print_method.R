#' @title Print an impact_indicator object
#'
#' @description Provides a summary representation of an impact_indicator object,
#'   designed for user-friendly display in the console.
#'
#' @method print impact_indicator
#'
#' @param x An impact_indicator object.
#' @param n (Optional) Integer specifying the number of rows of data to display.
#' @param ... Additional arguments.
#'
#' @examples
#' \dontrun{
#' # create data_cube
#' acacia_cube <- taxa_cube(
#'   taxa = taxa_Acacia,
#'   region = southAfrica_sf,
#'   res = 0.25,
#'   first_year = 2010
#' )
#'
#' # compute impact indicator
#' impact_value <- compute_impact_indicator(
#'   cube = acacia_cube,
#'   impact_data = eicat_acacia,
#'   method = "mean_cum",
#'   trans = 1
#' )
#'
#' # print impact indicator
#' print(impact_value)
#' }
#'
#' @export

print.impact_indicator <- function(x,n=10,...) {
  cat("Overall impact indicator\n\n")
  cat("Method:",x$method,"\n\n")
  cat("Number of cells:",x$num_cells,"\n\n")
  cat("Number of species:",x$num_species,"\n\n")
  cat("\nFirst", n, "rows of data (use n = to show more):\n\n")
  print(x$impact, n = n, ...)
}


#' @title Print an site_impact object
#'
#' @description Provides a summary representation of an site_impact object,
#'   designed for user-friendly display in the console.
#'
#' @method print site_impact
#'
#' @param x An site_impact object.
#' @param n (Optional) Integer specifying the number of rows of data to display.
#' @param ... Additional arguments.
#'
#' @examples
#' # create data_cube
#' acacia_cube <- taxa_cube(
#'   taxa = taxa_Acacia,
#'   region = southAfrica_sf,
#'   res = 0.25,
#'   first_year = 2010
#' )
#'
#' siteImpact <- compute_impact_per_site(
#'   cube = acacia_cube,
#'   impact_data = eicat_acacia,
#'   method = "mean_cum",
#'   trans = 1
#' )
#'
#' # print species impact
#' print(siteImpact)
#'
#' @export

print.site_impact <- function(x,n=10,...) {
  cat("Site impact indicator\n\n")
  cat("Method:",x$method,"\n\n")
  cat("Number of cells:",x$num_cells,"\n\n")
  cat("Number of species:",x$num_species,"\n\n")
  cat("\nFirst", n, "rows of data (use n = to show more):\n\n")
  print(x$site_impact, n = n, ...)
}



#' @title Print an species_impact object
#'
#' @description Provides a summary representation of an species_impact object,
#'   designed for user-friendly display in the console.
#'
#' @method print species_impact
#'
#' @param x An species_impact object.
#' @param n (Optional) Integer specifying the number of rows of data to display.
#' @param ... Additional arguments.
#'
#' @examples
#' # create data_cube
#' acacia_cube <- taxa_cube(
#'   taxa = taxa_Acacia,
#'   region = southAfrica_sf,
#'   res = 0.25,
#'   first_year = 2010
#' )
#'
#' # compute species impact
#' speciesImpact <- compute_impact_per_species(
#'   cube = acacia_cube,
#'   impact_data = eicat_acacia,
#'   method = "mean",
#'   trans = 1
#' )
#'
#' # print species impact
#' print(speciesImpact)
#'
#' @export

print.species_impact <- function(x,n=10,...) {
  cat("Site impact indicator\n\n")
  cat("Method:",x$method,"\n\n")
  cat("Number of species:",x$num_species,"\n\n")
  cat("\nFirst", n, "rows of data (use n = to show more):\n\n")
  print(x$species_impact, n = n, ...)
}
