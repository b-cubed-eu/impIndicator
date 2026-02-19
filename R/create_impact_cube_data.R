#' Create impact cube data
#'
#' @description
#' This function combines the occurrence cube data and impact data,
#' named impact_cube_data.
#'
#' @param cube_data A dataframe of a cube ( $data slot) of class `sim_cube` or `processed_cube` from
#' `b3gbi::process_cube()`.
#' @param impact_data The dataframe of species impact which contains columns of
#' `impact_category`, `scientific_name` and `impact_mechanism`.
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
#'
#' @returns A dataframe of containing impact data and occurrence cube. The class
#' is `impact_cube`
#' @export
#'
#' @examples
#'library(b3gbi) # for processing cube
#'acacia_cube <- process_cube(cube_name = cube_acacia_SA,
#'                           grid_type = "eqdgc",
#'                           first_year = 2010,
#'                            last_year = 2024)
#'
#' impact_cube <- create_impact_cube_data(
#'   cube_data = acacia_cube$data,
#'   impact_data = eicat_acacia,
#' )
#'
create_impact_cube_data<-function(cube_data,
                                  impact_data,
                                  trans = 1,
                                  col_category = NULL,
                                  col_species = NULL,
                                  col_mechanism = NULL,
                                  region = NULL){
  # avoid "no visible binding for global variable" NOTE for the following names
  cellCode <-  max_mech <- NULL

  if ("sim_cube" %in% class(cube_data) || "processed_cube" %in% class(cube_data)){
    cube_data<-cube_data$data
  } else if ( "data.frame" %in% class(cube_data)){
    cube_data<-cube_data
  } else {

    cli::cli_abort(
      c("{.var cube_data} must be a class {.cls data.frame}, {.cls sim_cube} or {.cls processed_cube}",
        "i" = "cube must be processed from `b3gbi`")
    )

  }

  # get species list
  full_species_list <- sort(unique(cube_data$scientificName))

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
  impact_cube_data <- dplyr::left_join(cube_data, impact_score_list,
                                       by = "scientificName"
  ) %>%
    tidyr::drop_na(max, mean, max_mech) #remove occurrences with no impact score

  # Extract cellCode that falls in the region if the region is provided
  if(!is.null(region)){
    cell_in_region <- intersect_cell_and_region(cube_data,region)

    # Select cells that falls in the given region
    impact_cube_data <- impact_cube_data %>%
      dplyr::filter(cellCode %in% cell_in_region)
  }

  class(impact_cube_data)<-c("impact_cube",class(impact_cube_data))
  return(impact_cube_data)
}
