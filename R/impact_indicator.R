#' Overall impact indicator
#'
#' @description
#' Combines occurrences cube and impact data using the given method
#' (e.g., mean cumulative) to compute the impact indicator of all
#' species over a given region
#'
#' @param cube A data cube object (class 'processed_cube' or 'sim_cube', processed
#' from `b3gbi::process_cube()`) or a dataframe (cf. `$data` slot of
#' 'processed_cube' or 'sim_cube') or an impact cube (class 'impact_cube' from
#' `create_impact_cube_data`)
#' @param impact_data A dataframe of species impact which contains columns of
#' `impact_category`, `scientific_name` and `impact_mechanism`.
#' @param method A method of computing the indicator. The method used in
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
#' @param region The shape file of the specific region to calculate the indicator on.
#' If NULL (default), the indicator is calculated for all cells in the cube.
#' @param ci A logical value. TRUE or FALSE (Default)
#' @param ci_type A character vector specifying the type of confidence intervals
#' to compute. Options include:
#'   - `"perc"`: Percentile interval (Default)
#'   - `"bca"`: Bias-corrected and accelerated interval
#'   - `"norm"`: Normal interval
#'   - `"basic"`: Basic interval
#' @param num_bootstrap The number of bootstrap replicates. A single positive integer.
#' Default is 1000.
#' @param grouping_var A character vector specifying the grouping variable(s)
#' for the bootstrap analysis. The function `fun()` should
#' return a row per group. The specified variables must not be redundant,
#' meaning they should not contain the same information (e.g., `"time_point"`
#' (1, 2, 3) and `"year"` (2000, 2001, 2002) should not be used together if
#' `"time_point"` is just an alternative encoding of `"year"`).
#' This variable is used to split the dataset into groups for separate
#' confidence interval calculations.
#' @param no_bias If TRUE intervals are centered around the original
#' estimates (bias is ignored). Default is TRUE
#' @param out_var A string specifying the column by which the data should be
#' left out iteratively. Default is `"taxonKey"` which can be used for
#' leave-one-species-out CV.
#' @param conf A numeric value specifying the confidence level of the intervals.
#'  Default is 0.95 (95 % confidence level).
#' @param seed A positive numeric value setting the seed for random number
#' generation to ensure reproducibility. If `NA` (default), then `set.seed()`
#' is not called at all. If not `NA`, then the random number generator state is
#' reset (to the state before calling this function) upon exiting this function.
#'
#' @return A list of class `impact_indicator`, with the following components:
#'    - `method`: method used in computing the indicator
#'    - `num_cells`: number of cells (sites) in the indicator
#'    - `num_species`:  number of species in the indicator
#'    - `names_species`: names of species in the indicator
#'    - `site_impact`: a dataframe containing total species impact per year
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
    col_mechanism = NULL,
    region = NULL,
    ci = FALSE,
    ci_type = "perc",
    num_bootstrap = 1000,
    grouping_var = "year",
    no_bias = TRUE,
    out_var = "taxonKey",
    conf = 0.95,
    seed = NA) {
  # avoid "no visible binding for global variable" NOTE for the following names
  taxonKey <- year <- cellCode <- max_mech <- scientificName <- NULL

  # check arguments
  # cube

  if ("sim_cube" %in% class(cube) || "processed_cube" %in% class(cube)){
    cube<-cube$data
  } else if ( "data.frame" %in% class(cube)){
    cube<-cube
  } else {

    cli::cli_abort(
      c("{.var cube} must be a class {.cls data.frame}, {.cls sim_cube} or {.cls processed_cube}",
        "i" = "cube must be processed from `b3gbi`")
    )

  }


  # region is NULL or an sf
  if(!(is.null(region) || "sf" %in% class(region))){
    cli::cli_abort(
      c("{.var region} is not a class {.cls sf}",
        "i" = "{.var region} must be a class {.cls sf} if provided")
    )
  }

  if (!(ci %in% c(TRUE,FALSE))){
    cli::cli_abort("'ci' must either be TRUE or FALSE")
  }

  # Create impact cube data if the cube is not have impact data
  if (!("impact_cube" %in% class(cube))){
    # merge occurrence cube and impact data
    impact_cube_data <- create_impact_cube_data(cube_data = cube,
                                                impact_data = impact_data,
                                                trans = trans,
                                                col_category = col_category,
                                                col_species = col_species,
                                                col_mechanism = col_mechanism,
                                                region = region)
  } else {
    impact_cube_data <- cube
    if(!(is.null(impact_data))){
      cli::cli_alert_warning("{.var cube} contains impact data. The {.var impact_data} was not used")
    }
  }


  # collect the number and names of species in the impact indicator
  num_of_species <- length(unique(impact_cube_data$scientificName))
  names_of_species <- sort(unique(impact_cube_data$scientificName))
  # collect number of cells
  num_of_cells <- length(unique(impact_cube_data$cellCode))

  if(ci == TRUE){
    # prepare indicator for bootstrap
    params <- prepare_indicators_bootstrap(impact_cube_data = impact_cube_data,
                                           indicator = "overall",
                                           indicator_method = method,
                                           num_bootstrap = num_bootstrap,
                                           ci_type = ci_type,
                                           grouping_var = grouping_var,
                                           no_bias = no_bias,
                                           out_var = out_var,
                                           conf = conf,
                                           seed = seed)



    # call bootstrap function from dubicube
    bootstrap_results <- do.call(dubicube::bootstrap_cube,params$bootstrap_params)

    # confidence interval function
    ci_result <- do.call(dubicube::calculate_bootstrap_ci,
                            c(bootstrap_results = list(bootstrap_results), params$ci_params))

    # clean confidence interval result

    impact_values <- ci_result %>%
      tibble::as_tibble() %>%
      dplyr::select(!dplyr::all_of(c("int_type","conf"))) %>%
      dplyr::rename("diversity_val" = "est_original")


  } else {


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

  }

  structure(list(method = method,
                 num_cells = num_of_cells,
                 num_species = num_of_species,
                 names_species = names_of_species,
                 impact = impact_values),
            class = "impact_indicator")
}
