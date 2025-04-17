#' Compute species impact indicator
#'
#' @param cube The data cube of class `sim_cube` or
#' `processed_cube` from `b3gbi::process_cube()`.
#' @param impact_data The dataframe of species impact which contains columns of
#' `impact_category`, `scientific_name` and `impact_mechanism`.
#' @param method The method of computing the indicator.
#' The method used in the aggregation of within impact of species.
#' The method can be "max", "mean" or "max_mech".
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
#'
#' @return A dataframe of impact indicator per species (class `species_impact`).
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
#' speciesImpact <- species_impact(
#'   cube = acacia_cube,
#'   impact_data = eicat_acacia,
#'   method = "mean",
#'   trans = 1
#' )

species_impact <- function(
    cube,
    impact_data = NULL,
    method = NULL,
    trans = 1,
    col_category = NULL,
    col_species = NULL,
    col_mechanism = NULL) {
  # avoid "no visible binding for global variable" NOTE for the following names
  taxonKey <- year <- cellCode <- max_mech <- scientificName <- NULL
  # check arguments
  # cube
  if (!("sim_cube" %in% class(cube) || "processed_cube" %in% class(cube))) {
    cli::cli_abort(
      c("{.var cube} must be a class {.cls sim_cube} or {.cls processed_cube}",
      "i" = "cube must be processed from `b3gbi`")
      )
  }

  # get species list
  full_species_list <- sort(unique(cube$data$scientificName))

  # get impact score list
  impact_score_list <- impact_cat(
    impact_data = impact_data,
    species_list = full_species_list,
    trans = trans,
    col_category = col_category,
    col_species = col_species,
    col_mechanism = col_mechanism
  )

  # create cube with impact score
  impact_cube_data <- dplyr::left_join(cube$data, impact_score_list,
                                       by = "scientificName"
  ) %>%
    tidyr::drop_na(max, mean, max_mech) #remove occurrences with no impact score

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
  class(species_values) <- c("species_impact", class(species_values))
  return(species_values)
}
