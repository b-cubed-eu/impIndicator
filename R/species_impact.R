#' Compute species impact indicator
#'
#' @param cube The list containing data cube of class `sim_cube` or
#' `processed_cube` from `b3gbi::process_cube()`.
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
#' @return A dataframe of impact indicator per species
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
#'   cube = acacia_cube$cube,
#'   impact_data = eicat_data,
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
  # check arguments
  # cube
  if (!("sim_cube" %in% class(cube))) {
    cli::cli_abort(c("{.var cube} must be a class {.cls sim_cube}",
      "i" = "cube must be processed from {pkg. b3gi}"
    ))
  }


  full_species_list <- sort(unique(cube$data$scientificName))

  period <- unique(cube$data$year)

  # create empty vector for species impact
  speciesImpact <- c()

  for (y in period) {
    sbs.taxon <- species_by_site(cube, y)

    species_list <- unique(names(sbs.taxon))

    if (!exists("eicat_score_list")) {
      eicat_score_list <- impact_cat(
        impact_data = impact_data,
        species_list = full_species_list,
        col_category = col_category,
        col_species = col_species,
        col_mechanism = col_mechanism,
        trans = trans
      )

      impact_species <- eicat_score_list %>%
        stats::na.omit() %>%
        rownames()
    }

    if (type == "max") {
      eicat_score <- eicat_score_list[species_list, type]
    } else if (type == "mean") {
      eicat_score <- eicat_score_list[species_list, type]
    } else if (type == "max_mech") {
      eicat_score <- eicat_score_list[species_list, type]
    } else {
      cli::cli_abort(c(
        "{.var type} should be one of max, mean or max_mech options"
      ))
    }

    # site by species impact
    impactScore <- sweep(sbs.taxon, 2, eicat_score, FUN = "*")
    # Species impact sport
    speciesScore <- colSums(impactScore, na.rm = TRUE) / cube$num_cells

    speciesImpact <- dplyr::bind_rows(speciesImpact, speciesScore)
  }


  speciesImpact <- speciesImpact %>%
    dplyr::select(dplyr::any_of(impact_species)) %>%
    as.data.frame()

  rownames(speciesImpact) <- as.character(period)
  class(speciesImpact) <- c("species_impact",class(speciesImpact))
  return(speciesImpact)
}
