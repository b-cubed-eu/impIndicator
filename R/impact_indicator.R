#' Impact indicator
#'
#' @description
#' Compute impact indicators of alien taxa
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

#' @return A list containing dataframes impact indicator, species impact indicator
#' and sites impact indicator
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
#'   impact_data = eicat_data,
#'   col_category = "impact_category",
#'   col_species = "scientific_name",
#'   col_mechanism = "impact_mechanism",
#'   trans = 1,
#'   type = "mean cumulative"
#' )
impact_indicator <- function(cube,
                             impact_data = NULL,
                             col_category = NULL,
                             col_species = NULL,
                             col_mechanism = NULL,
                             trans = 1,
                             type = NULL) {
  full_species_list <- sort(unique(cube$data$scientificName))

  period <- unique(cube$data$year)

  # create empty vector and dataframe for impact indicators and species impact
  # indicator
  impact_values <- c()
  species_values <- data.frame()

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

    if (type %in% c("precautionary", "precautionary cumulative")) {
      eicat_score <- eicat_score_list[species_list, "max"]

      # impact score multiply by species by site
      impactScore <- sweep(sbs.taxon, 2, eicat_score, FUN = "*")

      if (type == "precautionary") {
        siteScore <- apply(impactScore, 1, function(x) {
          max(x,
            na.rm = TRUE
          )
        }) %>%
          # suppress warning when -Inf produced  by max() due to site with no impact
          suppressWarnings()

        #d rop -Inf
        siteScore <- siteScore[siteScore!=-Inf]

        impact <- sum(siteScore, na.rm = TRUE) / cube$num_cells

        impact_values <- rbind(impact_values, c(y, impact))
      } else {
        # Precautionary cumulative
        siteScore <- apply(impactScore, 1, function(x) {
          sum(x,
            na.rm = TRUE
          )
        })


        impact <- sum(siteScore, na.rm = TRUE) / cube$num_cells
        impact_values <- rbind(impact_values, c(y, impact))
      }
    } else if (type %in% c("mean cumulative", "mean")) {
      eicat_score <- eicat_score_list[species_list, "mean"]

      # impact score multiply by species by site
      impactScore <- sweep(sbs.taxon, 2, eicat_score, FUN = "*")


      if (type == "mean cumulative") {
        siteScore <- apply(impactScore, 1, function(x) {
          sum(x,
            na.rm = TRUE
          )
        })

        impact <- sum(siteScore, na.rm = TRUE) / cube$num_cells
        impact_values <- rbind(impact_values, c(y, impact))
      } else {
        # mean
        siteScore <- apply(impactScore, 1, function(x) {
          mean(x,
            na.rm = TRUE
          )
        })


        impact <- sum(siteScore, na.rm = TRUE) / cube$num_cells
        impact_values <- rbind(impact_values, c(y, impact))
      }
    } else if (type == "cumulative") {
      eicat_score <- eicat_score_list[species_list, "max_mech"]

      # impact score multiply by species by site
      impactScore <- sweep(sbs.taxon, 2, eicat_score, FUN = "*")

      siteScore <- apply(impactScore, 1, function(x) {
        sum(x,
          na.rm = TRUE
        )
      })

      impact <- sum(siteScore, na.rm = TRUE) / cube$num_cells
      impact_values <- rbind(impact_values, c(y, impact))
    } else {
      cli::cli_abort(c(
        "{.var type} is not valid",
        "x" = "{.var type} must be from the options provided",
        "See the function desciption or double check the spelling"
      ))
    }
  }

  impact_values <- as.data.frame(impact_values)
  names(impact_values) <- c("year", "value")
  class(impact_values) <- c("impact_indicator", class(impact_values))
  return(impact_values)
}
