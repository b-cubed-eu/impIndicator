#' Compute species impact indicator
#'
#' @description
#' Combines occurrences cube and impact data using the given method
#' (e.g., mean) to compute the impact indicator per species.
#'
#' @param cube The data cube of class `sim_cube` or
#' `processed_cube` from `b3gbi::process_cube()`.
#' @param impact_data The dataframe of species impact which contains columns of
#' `impact_category`, `scientific_name` and `impact_mechanism`.
#' @param method The method of computing the indicator.
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
