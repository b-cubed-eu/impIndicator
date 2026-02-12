#' Compute species impact indicator
#'
#' @description
#' Combines occurrences cube and impact data using the given method
#' (e.g., mean) to compute the impact indicator per species.
#'
#' @param cube A data cube object (class 'processed_cube' or 'sim_cube', processed
#' from `b3gbi::process_cube()`) or a dataframe (cf. `$data` slot of
#' 'processed_cube' or 'sim_cube') or an impact cube (class 'impact_cube' from
#' `create_impact_cube_data`)
#' @param impact_data A dataframe of species impact which contains columns of
#' `impact_category`, `scientific_name` and `impact_mechanism`.
#' @param method A method of computing the indicator.
#' The method used in the aggregation of within impact of species.
#' The method can be
#' - `"max"`:The maximum method assigns a species the maximum impact across all
#' records of the species. It is best for precautionary approaches.
#' Also, the assumption is that the management of the highest impact can
#'  cover for the lower impact caused by a species and can be the best
#'  when there is low confidence in the multiple impacts of species of interest.
#'  However, the maximum method can overestimate the impact of a species
#'  especially when the highest impact requires specific or rare conditions and
#'  many lower impacts were recorded.
#' - `"mean"`: assigns a species the mean impact of all the species impact.
#' This method computes the expected impact of the species considering
#' all species impact without differentiating between
#' impacts. This method is adequate when there are many
#' impact records per species.
#' - `"max_mech"`: Assigns a species the summation of the maximum impact
#' per mechanism. The assumption is that species with
#' many mechanisms of impact have a higher potential to cause impact.
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
#' @return A list of class `species_impact`, with the following components:
#'    - `method`: method used in computing the indicator
#'    - `num_species`: number of species in the indicator
#'    - `names_species`: names of species in the indicator
#'    - `species_impact`: a dataframe containing impact per species
#'
#' @export
#'
#' @family Indicator function
#'
#' @examples
#' acacia_cube <- taxa_cube(
#'   taxa = taxa_Acacia,
#'   region = southAfrica_sf,
#'   res = 0.25,
#'   first_year = 2010
#' )
#'
#' speciesImpact <- compute_impact_per_species(
#'   cube = acacia_cube,
#'   impact_data = eicat_acacia,
#'   method = "mean",
#'   trans = 1
#' )

compute_impact_per_species <- function(
    cube,
    impact_data = NULL,
    method = NULL,
    trans = 1,
    col_category = NULL,
    col_species = NULL,
    col_mechanism = NULL,
    region = NULL) {
  # avoid "no visible binding for global variable" NOTE for the following names
  taxonKey <- year <- cellCode <- max_mech <- scientificName <- NULL
  # check arguments
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

  # Create impact cube data if the cube is not have impact data
  if (!("impact_cube" %in% class(cube))){
    # merge occurrence cube and impact data
    impact_cube_data <- create_impact_cube_data(cube_data = cube,
                                                impact_data = impact_data,
                                                trans = trans,
                                                col_category = col_category,
                                                col_species = col_species,
                                                col_mechanism = col_mechanism,
                                                region = region)
  } else {
    impact_cube_data <- cube
    if(!(is.null(impact_data))){
      cli::cli_alert_warning("{.var cube} contains impact data. The {.var impact_data} was not used")
    }
  }


  # collect the number and names of species in the impact indicator
  num_of_species <- length(unique(impact_cube_data$scientificName))
  names_of_species <- sort(unique(impact_cube_data$scientificName))

  if (method == "max") {
    species_values<-compute_species_impact(impact_cube_data,"max")
  } else if (method == "mean") {
    species_values<-compute_species_impact(impact_cube_data,"mean")
  } else if (method == "max_mech") {
    species_values<-compute_species_impact(impact_cube_data,"max_mech")
  } else {
    cli::cli_abort(c(
      "{.var method} should be one of max, mean or max_mech options"
    ))
  }
  species_values <- tibble::as_tibble(species_values)

  structure(list(method = method,
                 num_species = num_of_species,
                 names_species = names_of_species,
                 species_impact = species_values),
            class = "species_impact")
}
