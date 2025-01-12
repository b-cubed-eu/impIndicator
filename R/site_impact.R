#' Compute site impact indicator
#'
#' @param cube The data cube of class `sim_cube` or `processed_cube` from
#' `b3gbi::process_cube()`
#' @param impact_data The dataframe of species impact which contains columns of `impact_category,`
#' `scientific_name` and `impact_mechanism`
#' @param col_category The name of the column containing the impact categories.
#' The first two letters each categories must be an EICAT short names
#' (e.g "MC - Minimal concern")
#' @param col_species The name of the column containing species names
#' @param col_mechanism The name of the column containing mechanisms of impact
#' @param trans Numeric. The type of transformation to convert the EICAT categories to
#' numerical values. 1 converts ("MC", "MN", "MO", "MR", "MV") to (0,1,2,3,4)
#' 2 converts ("MC", "MN", "MO", "MR", "MV") to (1,2,3,4,5) and
#' 3 converts ("MC", "MN", "MO", "MR", "MV") to (1,10,100,1000,10000)
#' @param type The type indicators based on the aggregation of within and
#' across species in a site. The type can be precautionary, precautionary cumulative,
#' mean, mean cumulative or cumulative.
#'
#' @return The dataframe of impact indicator per sites (class `site_impact`)
#' @export
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
#' siteImpact <- site_impact(
#'   cube = acacia_cube,
#'   impact_data = eicat_acacia,
#'   trans = 1,
#'   type = "precautionary cumulative"
#' )
#'
site_impact <- function(cube,
                        impact_data = NULL,
                        col_category = NULL,
                        col_species = NULL,
                        col_mechanism = NULL,
                        trans = 1,
                        type = NULL) {
  # avoid "no visible binding for global variable" NOTE for the following names
  cellCode <- xcoord <- ycoord <-  taxonKey <- year <- max_mech<- NULL

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
    col_category = col_category,
    col_species = col_species,
    col_mechanism = col_mechanism,
    trans = trans
  )

  # create cube with impact score
  impact_cube_data <- dplyr::left_join(cube$data, impact_score_list,
                                       by = "scientificName"
  ) %>%
    tidyr::drop_na(max, mean, max_mech) #remove occurrences with no impact score

  if (type == "precautionary") {
    site_values <- impact_cube_data %>%
      dplyr::distinct(taxonKey, year, cellCode, .keep_all = TRUE) %>%
      dplyr::group_by(year, cellCode, xcoord, ycoord) %>%
      dplyr::summarise(dplyr::across(max, max), .groups = "drop") %>%
      tidyr::pivot_wider(names_from = year, values_from = max)
  } else if (type == "precautionary cumulative") {
    site_values <- impact_cube_data %>%
      dplyr::distinct(taxonKey, year, cellCode, .keep_all = TRUE) %>%
      dplyr::group_by(year, cellCode, xcoord, ycoord) %>%
      dplyr::summarise(dplyr::across(max, sum), .groups = "drop") %>%
      tidyr::pivot_wider(names_from = year, values_from = max)
  } else if (type == "mean") {
    site_values <- impact_cube_data %>%
      dplyr::distinct(taxonKey, year, cellCode, .keep_all = TRUE) %>%
      dplyr::group_by(year, cellCode, xcoord, ycoord) %>%
      dplyr::summarise(dplyr::across(mean, mean), .groups = "drop") %>%
      tidyr::pivot_wider(names_from = year, values_from = mean)
  } else if (type == "mean cumulative") {
    site_values <- impact_cube_data %>%
      dplyr::distinct(taxonKey, year, cellCode, .keep_all = TRUE) %>%
      dplyr::group_by(year, cellCode, xcoord, ycoord) %>%
      dplyr::summarise(dplyr::across(mean, sum), .groups = "drop") %>%
      tidyr::pivot_wider(names_from = year, values_from = mean)
  } else if (type == "cumulative") {
    site_values <- impact_cube_data %>%
      dplyr::distinct(taxonKey, year, cellCode, .keep_all = TRUE) %>%
      dplyr::group_by(year, cellCode, xcoord, ycoord) %>%
      dplyr::summarise(dplyr::across(max_mech, sum), .groups = "drop") %>%
      tidyr::pivot_wider(names_from = year, values_from = max_mech)
  } else {
    cli::cli_abort(c(
      "{.var type} is not valid",
      "x" = "{.var type} must be from the options provided",
      "See the function desciption or double check the spelling"
    ))
  }


  class(site_values)<-c("site_impact",class(site_values))
  return(site_values)
}
