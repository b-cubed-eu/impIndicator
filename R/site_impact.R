#' Site impact indicator
#'
#' @description
#' Combines occurrences cube and impact data using the given method
#' (e.g., mean cumulative) to compute the impact indicator per site.
#'
#' @param cube The data cube of class `sim_cube` or `processed_cube` from
#' `b3gbi::process_cube()`.
#' @param impact_data The dataframe of species impact which contains columns of
#' `impact_category`, `scientific_name` and `impact_mechanism`.
#' @param method The method of computing the indicator. The method used in
#' the aggregation of within and across species in a site proposed
#' by Boulesnane-Genguant et al. (submitted).
#' The method can be one of
#'   -  `"precaut"`: The "``precautionary``" method assigns a species the
#'   maximum impact across all records of the species and then compute the
#'   maximum impact across species in each site
#'   - `"precaut_cum"`: The "``precautionary cumulative``" method assigns a
#'   species the maximum impact across all records of the species then
#'   compute the summation of all impacts in each site.
#'   The precautionary cumulative method provides the highest
#'   impact score possible for each species but considers
#'   the number of co-occurring species in each site.
#'   - `"mean"`:The "``mean``" method assigns species the mean impact of all
#'   the species impact and then computes the mean of all species in each site.
#'   The mean provides the expected impact within individual species and
#'   across all species in each site.
#'   - `"mean_cum"`: The "``mean cumulative``" assigns a species the mean
#'   impact of all the species impact and then computes the summation of all
#'   impact scores in each site. The mean cumulative provides the expected
#'   impact score within individual species but adds co-occurring species’
#'   impact scores in each site.
#'   - `"cum"`: The "``cumulative``" assigns a species the summation of the
#'   maximum impact per mechanism and then computes the summation of
#'   all species’ impacts per site. The cumulative method provides a
#'   comprehensive view of the overall impact while considering the impact
#'   and mechanisms of multiple species.
#' @param trans Numeric: `1` (default), `2` or `3`. The method of transformation
#' to convert the EICAT categories `c("MC", "MN", "MO", "MR", "MV")` to
#' numerical values:
#'   - `1`: converts the categories to `c(0, 1, 2, 3, 4)`
#'   - `2`: converts the categories to to `c(1, 2, 3, 4, 5)`
#'   - `3`: converts the categories to to `c(1, 10, 100, 1000, 10000)`
#' @param col_category The name of the column containing the impact categories.
#' The first two letters each categories must be an EICAT short names
#' (e.g "MC - Minimal concern").
#' @param col_species The name of the column containing species names.
#' @param col_mechanism The name of the column containing mechanisms of impact.
#' @param region The shape file of the specific region to calculate the indicator on.
#' If NULL (default), the indicator is calculated for all cells in the cube.

#' @return A list of class `site_impact`, with the following components:
#'    - `method`: method used in computing the indicator
#'    - `num_cells`: number of cells (sites) in the indicator
#'    - `num_species`:  number of species in the indicator
#'    - `site_impact`: a dataframe containing impact per sites
#'
#' @export
#'
#' @family Indicator function
#'
#' @examples
#' # define cube for taxa
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

compute_impact_per_site <- function(
    cube,
    impact_data = NULL,
    method = NULL,
    trans = 1,
    col_category = NULL,
    col_species = NULL,
    col_mechanism = NULL,
    region = NULL) {


  # check arguments
  # cube
  if ("sim_cube" %in% class(cube) || "processed_cube" %in% class(cube)){
    cube<-cube$data
  } else if ( "data.frame" %in% class(cube)){
    cube<-cube
  } else {

    cli::cli_abort(
      c("{.var cube} must be a class {.cls data.frame}, {.cls sim_cube} or {.cls processed_cube}",
        "i" = "cube must be processed from `b3gbi`")
    )

  }
  # region is NULL or an sf
  if(!(is.null(region) || "sf" %in% class(region))){
    cli::cli_abort(
      c("{.var region} is not a class {.cls sf}",
        "i" = "{.var region} must be a class {.cls sf} if provided")
    )
  }

  # merge occurrence cube and impact data
  impact_cube_data <- create_impact_cube_data(cube_data = cube,
                          impact_data = impact_data,
                          trans = trans,
                          col_category = col_category,
                          col_species = col_species,
                          col_mechanism = col_mechanism,
                          region = region)


  # collect number of species
  num_of_species <- length(unique(impact_cube_data$scientificName))

  if (method == "precaut") {
    site_values <- compute_site_impact(impact_cube_data,"max",max)
  } else if (method == "precaut_cum") {
    site_values <- compute_site_impact(impact_cube_data,"max",sum)
  } else if (method == "mean") {
    site_values <- compute_site_impact(impact_cube_data,"mean",mean)
  } else if (method == "mean_cum") {
    site_values <- compute_site_impact(impact_cube_data,"mean",sum)
  } else if (method == "cum") {
    site_values <- compute_site_impact(impact_cube_data,"max_mech",sum)
  }  else {
    cli::cli_abort(c(
      "{.var method} is not valid",
      "x" = "{.var method} must be from the options provided",
      "See the function desciption or double check the spelling"
    ))
  }

  # collect number of cells
  num_of_cells <- length(site_values$cellCode)

  structure(list(method = method,
                 num_cells = num_of_cells,
                 num_species = num_of_species,
                 site_impact = site_values),
            class = "site_impact")

}
