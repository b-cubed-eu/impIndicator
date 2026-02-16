#' Prepare indicators for bootstrap  and cross validation
#'
#' @param impact_cube_data An impact cube object (class 'impact_cube' from `create_impact_cube_data`)
#' @param indicator An impact indicator to be computed. Options are 'overall',
#' 'site', and 'species'.
#' @param indicator_method A method to compute impact indicator (see methods in `impact_indicator`)
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
#' @param ci_type A character vector specifying the type of confidence intervals
#' to compute. Options include:
#'   - `"perc"`: Percentile interval (Default)
#'   - `"bca"`: Bias-corrected and accelerated interval
#'   - `"norm"`: Normal interval
#'   - `"basic"`: Basic interval
#' @param no_bias Logical. If TRUE intervals are centered around the original
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
#' @return A named list with two items:
#' \describe{
#'   \item{bootstrap_params}{List of parameters for \code{bootstrap_cube()}}
#'   \item{ci_params}{List of parameters for \code{calculate_bootstrap_ci()}}
#' }
#'
#' @export
#'
#' @examples
#' library(b3gbi) # for processing cube
#' acacia_cube <- process_cube(
#'   cube_name = cube_acacia_SA,
#'   grid_type = "eqdgc",
#'   first_year = 2010,
#'   last_year = 2024
#' )
#'
#' impact_cube <- create_impact_cube_data(
#'   cube_data = acacia_cube$data,
#'   impact_data = eicat_acacia,
#' )
#'
#' prepare_indicators_bootstrap(
#'   impact_cube_data = impact_cube,
#'   indicator = "overall",
#'   indicator_method = "mean_cum"
#' )
prepare_indicators_bootstrap <- function(impact_cube_data,
                                         indicator = c("overall", "site", "species"),
                                         indicator_method,
                                         num_bootstrap = 1000,
                                         grouping_var = "year",
                                         ci_type = "perc",
                                         no_bias = TRUE,
                                         out_var = "taxonKey",
                                         conf = 0.95,
                                         seed = NA) {

  # Check impact_cube_data
  if(!("impact_cube" %in% class(impact_cube_data))){
    cli::cli_abort(c("{.var impact_cube_data} must be an impact cube object",
                     "x"="{.var impact_cube_data} is not a {.cls impact_cube}"))
  }

  # Check type of indicator
  indicator <- match.arg(indicator)


  if (indicator %in% c("site", "species")) {
    cli::cli_abort("There is no method for indicator {indicator} currently")
  }


  # Boot function for overall impact indicator
  boot_function <- function(impact_cube_data,
                            indicator_method) {
    if (indicator_method == "precaut") {
      impact_values <- compute_impact_indicators(impact_cube_data,"max",max)
    } else if (indicator_method == "precaut_cum") {
      impact_values <- compute_impact_indicators(impact_cube_data,"max",sum)
    } else if (indicator_method == "mean") {
      impact_values <- compute_impact_indicators(impact_cube_data,"mean",mean)
    } else if (indicator_method == "mean_cum") {
      impact_values <- compute_impact_indicators(impact_cube_data,"mean",sum)
    } else if (indicator_method == "cum") {
      impact_values <- compute_impact_indicators(impact_cube_data,"max_mech",sum)
    } else {
      cli::cli_abort(c(
        "{.var indicator_method} is not valid",
        "x" = "{.var indicator_method} must be from the options provided",
        "See the function desciption or double check the spelling"
      ))
    }
    impact_values
  }

  # Bootstrap parameter
  bootstrap_params <- list(
    data_cube = impact_cube_data,
    fun = boot_function,
    indicator_method = indicator_method,
    samples = num_bootstrap,
    grouping_var = grouping_var,
    processed_cube = FALSE,
    seed = seed,
    method = "whole_cube"
  )

  # Confidence interval parameter
  ci_params <- list(
    grouping_var = grouping_var,
    type = ci_type,
    no_bias = no_bias
  )

  # Cross-validation parameter
  cv_params<- list(
    data_cube = impact_cube_data,
    fun = boot_function,
    indicator_method = indicator_method,
    grouping_var = grouping_var,
    out_var = out_var,
    processed_cube = FALSE
  )

  return(
    list(bootstrap_params = bootstrap_params,
         ci_params = ci_params,
         cv_params = cv_params)
  )
}
