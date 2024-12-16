#' Compute site impact indicator
#'
#' @param cube The list containing data cube of class `sim_cube` or `process_cube`from
#' `b3gbi::process_cube()`.
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
#' @param coords The dataframe containing coordinates of the sites of the region.
#'
#' @return The dataframe of impact indicator per sites
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
#'   cube = acacia_cube$cube,
#'   impact_data = eicat_data,
#'   col_category = "impact_category",
#'   col_species = "scientific_name",
#'   col_mechanism = "impact_mechanism",
#'   trans = 1,
#'   type = "precautionary cumulative",
#'   coords = acacia_cube$coords
#' )
#'
site_impact <- function(cube,
                        impact_data = NULL,
                        col_category = NULL,
                        col_species = NULL,
                        col_mechanism = NULL,
                        trans = 1,
                        type = NULL,
                        coords = NULL) {
  # check arguments
  # cube
  if (!("sim_cube" %in% class(cube))) {
    cli::cli_abort(c("{.var cube} must be a class {.cls sim_cube}",
      "i" = "cube must be processed from {pkg. b3gi}"
    ))
  }

  if (!("data.frame" %in% class(coords)) &
    !all(c("siteID", "X", "Y") %in% names(coords))) {
    cli::cli_abort(
      "{.var coords} must be a {.cls dataframe} with columns {.var siteID},{.var X} and {.var Y}"
    )
  }


  full_species_list <- sort(unique(cube$data$scientificName))

  period <- unique(cube$data$year)

  for (y in period) {
    sbs.taxon <- species_by_site(cube = cube, y = y)

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
          suppressWarnings()
      } else { # elsecompute precautionary cumulative
        siteScore <- apply(impactScore, 1, function(x) {
          sum(x,
            na.rm = TRUE
          )
        })
      }
    } else if (type %in% c("mean cumulative", "mean")) {
      eicat_score <- eicat_score_list[species_list, "mean"]

      # impact score multiply by species by site
      impactScore <- sweep(sbs.taxon, 2, eicat_score, FUN = "*")

      if (type == "mean") {
        siteScore <- apply(impactScore, 1, function(x) {
          mean(x,
            na.rm = TRUE
          )
        })
      } else { # else compute mean cumulative
        siteScore <- apply(impactScore, 1, function(x) {
          sum(x,
            na.rm = TRUE
          )
        })
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
    } else {
      cli::cli_abort(c(
        "{.var type} is not valid",
        "i" = "{.var type} must be from the options provided",
        "See the function desciption OR check double the check spelling"
      ))
    }

    # convert siteScore to dataframe
    siteScore <- siteScore %>%
      as.data.frame() %>%
      tibble::rownames_to_column(var = "siteID")

    names(siteScore)[2] <- as.character(y)

    coords <- dplyr::left_join(coords, siteScore, by = "siteID")
  }

  # remove -Inf produced by max(.,na.rm=TRUE)
  # remove NaN produced by mean(.,na.rm=TRUE)
  # remove 0 produced by sum(.,na.rm=TRUE)

  coords <- coords %>%
    dplyr::mutate(dplyr::across(
      dplyr::all_of(dplyr::everything()),
      ~ ifelse(. == -Inf | is.nan(.) | . == 0, NA, .)
    ))

  return(coords)
}
