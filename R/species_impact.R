#' Compute species impact indicator
#'
#' @param cube The data cube of class `sim_cube` or
#' `processed_cube` from `b3gbi::process_cube()`
#' @param impact_data The dataframe of species impact which contains columns of category,
#'  species and mechanism.
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
#' @return A dataframe of impact indicator per species (class `species_impact`)
#' @export
#'
#' @examples
#'
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
#'   col_category = "impact_category",
#'   col_species = "scientific_name",
#'   col_mechanism = "impact_mechanism",
#'   trans = 1,
#'   type = "mean"
#' )
species_impact <- function(cube,
                           impact_data = NULL,
                           col_category = NULL,
                           col_species = NULL,
                           col_mechanism = NULL,
                           trans = 1,
                           type = NULL) {

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

  if (type == "max") {
    species_values<-impact_cube_data %>%
      # keep only one occurrence of a species at each site per year
      dplyr::distinct(taxonKey,year,cellCode,.keep_all = TRUE) %>%
      dplyr::group_by(year,scientificName) %>%
      dplyr::summarise(dplyr::across(max,sum),.groups = "drop") %>%
      dplyr::mutate(max = max/cube$num_cells) %>%
      dplyr::arrange(scientificName) %>%
      tidyr::pivot_wider(names_from = scientificName, values_from = max) %>%
      dplyr::arrange(year) %>%
      tibble::column_to_rownames(var="year")
  } else if (type == "mean") {
    species_values<-impact_cube_data %>%
      # keep only one occurrence of a species at each site per year
      dplyr::distinct(taxonKey,year,cellCode,.keep_all = TRUE) %>%
      dplyr::group_by(year,scientificName) %>%
      dplyr::summarise(dplyr::across(mean,sum),.groups = "drop") %>%
      dplyr::mutate(mean = mean/cube$num_cells) %>%
      dplyr::arrange(scientificName) %>%
      tidyr::pivot_wider(names_from = scientificName, values_from = mean) %>%
      dplyr::arrange(year) %>%
      tibble::column_to_rownames(var="year")
  } else if (type == "max_mech") {
    species_values<-impact_cube_data %>%
      # keep only one occurrence of a species at each site per year
      dplyr::distinct(taxonKey,year,cellCode,.keep_all = TRUE) %>%
      dplyr::group_by(year,scientificName) %>%
      dplyr::summarise(dplyr::across(max_mech,sum),.groups = "drop") %>%
      dplyr::mutate(max_mech = max_mech/cube$num_cells) %>%
      dplyr::arrange(scientificName) %>%
      tidyr::pivot_wider(names_from = scientificName, values_from = max_mech) %>%
      dplyr::arrange(year) %>%
      tibble::column_to_rownames(var="year")
  } else {
    cli::cli_abort(c(
      "{.var type} should be one of max, mean or max_mech options"
    ))
  }
  species_values<-tibble::as_tibble(species_values)
  class(species_values) <- c("species_impact", class(species_values))
  return(species_values)
}
