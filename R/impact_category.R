#' Compute impact categories
#'
#' @description
#' Aggregate species impact categories from impact data.
#'
#' @param impact_data The dataframe of species impact which contains columns of `impact_category,`
#' `scientific_name` and `impact_mechanism.`
#' @param species_list The vector of species' list to aggregate their impact categories
#' @param col_category The name of the column containing the impact categories.
#' The first two letters each categories must be an EICAT short names
#' (e.g "MC -Minimal concern")
#' @param col_species The name of the column containing species names
#' @param col_mechanism The name of the column containing mechanisms of impact
#' @param trans Numeric. The type of transformation to convert the EICAT categories to
#' numerical values. 1 converts ("MC", "MN", "MO", "MR", "MV") to (0,1,2,3,4)
#' 2 converts ("MC", "MN", "MO", "MR", "MV") to (1,2,3,4,5) and
#' 3 converts ("MC", "MN", "MO", "MR", "MV") to (1,10,100,1000,10000)
#'
#' @return The dataframe containing the aggregated species impact. max - maximum
#' impact of a species. mean - mean impact of a species. max_mech - sum of maximum
#' impact per categories of a species
#' @export
#'
#' @examples
#' # define species list
#' species_list <- c(
#'   "Acacia adunca",
#'   "Acacia baileyana",
#'   "Acacia binervata",
#'   "Acacia crassiuscula",
#'   "Acacia cultriformis",
#'   "Acacia cyclops",
#'   "Acacia dealbata",
#'   "Acacia decurrens",
#'   "Acacia elata"
#' )
#'
#' agg_impact <- impact_cat(
#'   impact_data = eicat_acacia,
#'   species_list = species_list,
#'   trans = 1
#' )
#'
impact_cat <- function(impact_data,
                       species_list,
                       col_category = NULL,
                       col_species = NULL,
                       col_mechanism = NULL,
                       trans = 1) {
  # avoid "no visible binding for global variable" NOTE for the followin names
  impact_category <- scientific_name <- impact_mechanism <- category_value <- . <- scientificName<-rowname <- NULL


  # check arguments
  # impact_data
  if (!("data.frame" %in% class(impact_data))) {
    cli::cli_abort("{.var impact_data} must be a {.cls dataframe}")
  }

  # species_list
  if (!("character" %in% class(species_list))) {
    cli::cli_abort("{.var species_list} must be a {.cls character}")
  }

  # trans
  if (!(trans %in% 1:3)) {
    cli::cli_abort(c("{.var trans} must be a number from 1,2 or 3",
      "i" = "see the function documentation for details"
    ))
  }


  if (all(c(
    "impact_category",
    "scientific_name",
    "impact_mechanism"
  ) %in% names(impact_data))) {
    impact_data <- impact_data
  } else if (all(c(
    !is.null(col_category),
    !is.null(col_species),
    !is.null(col_mechanism)
  ))) {
    impact_data <- impact_data %>%
      dplyr::rename(dplyr::all_of(c(
        impact_category = col_category,
        scientific_name = col_species,
        impact_mechanism = col_mechanism
      )))
  } else {
    cli::cli_abort(c(
      "columns {.var impact_category}, {.var scientific_name} and {.var impact_mechanism} are not found in the {.var impact_data}",
      "i" = "columns {.var col_category}, {.var col_species} and {.var col_mechanism} must all be given"
    ))
  }

  category_max_mean <- impact_data %>%
    dplyr::mutate(impact_category = substr(impact_category, 1, 2)) %>%
    dplyr::filter(impact_category %in% c("MC", "MN", "MO", "MR", "MV")) %>%
    dplyr::select(scientific_name, impact_mechanism, impact_category) %>%
    dplyr::mutate(category_value = cat_num(impact_category, trans)) %>%
    dplyr::distinct(scientific_name, impact_mechanism, impact_category,
      .keep_all = TRUE
    ) %>%
    dplyr::group_by(scientific_name) %>%
    dplyr::summarise(
      max_value = max(category_value, na.rm = TRUE),
      mean_value = mean(category_value, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    dplyr::filter(scientific_name %in% species_list)


  category_sum_mech <- impact_data %>%
    dplyr::mutate(impact_category = substr(impact_category, 1, 2)) %>%
    dplyr::filter(impact_category %in% c("MC", "MN", "MO", "MR", "MV")) %>%
    dplyr::select(scientific_name, impact_mechanism, impact_category) %>%
    dplyr::mutate(category_value = cat_num(impact_category, trans)) %>%
    dplyr::distinct(scientific_name, impact_mechanism, impact_category,
      .keep_all = TRUE
    ) %>%
    dplyr::group_by(scientific_name, impact_mechanism) %>%
    dplyr::summarise(dplyr::across(category_value, max),
      .groups = "drop"
    ) %>%
    dplyr::group_by(scientific_name) %>%
    dplyr::summarise(dplyr::across(category_value, sum),
      .groups = "drop"
    ) %>%
    dplyr::filter(scientific_name %in% species_list)

  category_M <- dplyr::left_join(category_max_mean, category_sum_mech,
    by = dplyr::join_by(scientific_name)
  ) %>%
    tibble::column_to_rownames(var = "scientific_name")

  names(category_M) <- c("max", "mean", "max_mech")

  impact_matrix <- category_M

  na.df <- as.data.frame(matrix(NA,
    nrow = length(setdiff(
      species_list,
      rownames(impact_matrix)
    )),
    ncol = ncol(impact_matrix)
  ))
  row.names(na.df) <- setdiff(species_list, rownames(impact_matrix))
  names(na.df) <- names(impact_matrix) # column names
  impact_matrix <- rbind(impact_matrix, na.df)


  impact_matrix <- impact_matrix %>%
    dplyr::mutate(scientificName = row.names(.)) %>%
    dplyr::arrange(scientificName)

  return(impact_matrix)
}
