#' Impact indicator
#'
#' @description
#' Compute impact indicators of alien taxa
#'
#' @param cube The data cube of class `sim_cube` or `processed_cube` from
#' `b3gbi::process_cube()`
#' @param impact_data The dataframe of species impact which contains columns of `impact_category,`
#' `scientific_name` and `impact_mechanism`
#' @param method The method of computing the indicator. The method used in
#' the aggregation of within and across species in a site.
#' The method can be precautionary, precautionary cumulative, mean,
#' mean cumulative or cumulative.
#' @param trans Numeric. The method of transformation to convert the EICAT categories to
#' numerical values. 1 converts ("MC", "MN", "MO", "MR", "MV") to (0,1,2,3,4)
#' 2 converts ("MC", "MN", "MO", "MR", "MV") to (1,2,3,4,5) and
#' 3 converts ("MC", "MN", "MO", "MR", "MV") to (1,10,100,1000,10000)
#' @param col_category The name of the column containing the impact categories.
#' The first two letters of each categories must be an EICAT short names
#' (e.g "MC - Minimal concern")
#' @param col_species The name of the column containing species names
#' @param col_mechanism The name of the column containing mechanisms of impact
#' @return A dataframe of the invasive alien impact trend (class `impact_indicator`)
#' @export
#'
#' @examples
#' acacia_cube <- taxa_cube(
#'   taxa = taxa_Acacia,
#'   region = southAfrica_sf,
#'   res = 0.25,
#'   first_year = 2010
#' )
#' impact_value <- impact_indicator(
#'   cube = acacia_cube,
#'   impact_data = eicat_acacia,
#'   method = "mean cumulative",
#'   trans = 1
#' )
impact_indicator <- function(cube,
                             impact_data = NULL,
                             col_category = NULL,
                             col_species = NULL,
                             col_mechanism = NULL,
                             trans = 1,
                             method = NULL) {
  # avoid "no visible binding for global variable" NOTE for the following names
  taxonKey <- year <- cellCode <- max_mech <- scientificName <- NULL

  # check arguments
  # cube
  if (!("sim_cube" %in% class(cube) | "processed_cube" %in% class(cube))) {
    cli::cli_abort(c("{.var cube} must be a class {.cls sim_cube} or {.cls processed_cube}",
      "i" = "cube must be processed from `b3gbi`"
    ))
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
    tidyr::drop_na(max, mean, max_mech) # remove occurrences with no impact score


  if (method == "precautionary") {
    impact_values <- prec_indicator(impact_cube_data)
  } else if (method == "precautionary cumulative") {
    impact_values <- prec_cum_indicator(impact_cube_data)
  } else if (method == "mean") {
    impact_values <- mean_indicator(impact_cube_data)
  } else if (method == "mean cumulative") {
    impact_values <- mean_cum_indicator(impact_cube_data)
  } else if (method == "cumulative") {
    impact_values <- cum_indicator(impact_cube_data)
  } else {
    cli::cli_abort(c(
      "{.var method} is not valid",
      "x" = "{.var method} must be from the options provided",
      "See the function desciption or double check the spelling"
    ))
  }

  class(impact_values) <- c("impact_indicator", class(impact_values))
  return(impact_values)
}
