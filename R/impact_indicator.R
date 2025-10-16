#' Overall impact indicator
#'
#' @description
#' Combines occurrences cube and impact data using the given method
#' (e.g., mean cumulative) to compute the impact indicator of all
#' species over a given region
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
#'
#' @return A dataframe of the invasive alien impact trend
#' (class `impact_indicator`)
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
#' impact_value <- compute_impact_indicator(
#'   cube = acacia_cube,
#'   impact_data = eicat_acacia,
#'   method = "mean_cum",
#'   trans = 1
#' )

compute_impact_indicator <- function(
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
  impact_cube_data <- dplyr::left_join(
    cube$data, impact_score_list, by = "scientificName") %>%
    # remove occurrences with no impact score
    tidyr::drop_na(max, mean, max_mech)


  if (method == "precaut") {
    impact_values <- compute_impact_indicators(impact_cube_data,"max",max)
  } else if (method == "precaut_cum") {
    impact_values <- compute_impact_indicators(impact_cube_data,"max",sum)
  } else if (method == "mean") {
    impact_values <- compute_impact_indicators(impact_cube_data,"mean",mean)
  } else if (method == "mean_cum") {
    impact_values <- compute_impact_indicators(impact_cube_data,"mean",sum)
  } else if (method == "cum") {
    impact_values <- compute_impact_indicators(impact_cube_data,"max_mech",sum)
  } else {
    cli::cli_abort(c(
      "{.var method} is not valid",
      "x" = "{.var method} must be from the options provided",
      "See the function desciption or double check the spelling"
    ))
  }
  structure(list(method = method,
                 impact = impact_values),
            class = "impact_indicator")

}
