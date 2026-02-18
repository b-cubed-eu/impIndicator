#' Prepare indicators for bootstrap and cross validation
#'
#' @description
#' Create the parameter lists required to perform bootstrapping
#' (`dubicube::bootstrap_cube()`), calculate confidence intervals
#' (`dubicube::calculate_bootstrap_ci()`), and perform cross-validation
#' (`dubicube::cross_validate_cube()`).
#'
#' This function is primarily intended for internal use by indicator
#' functions, but can also be used directly to construct parameter lists
#' for manual calls to the underlying `dubicube` functions.
#'
#' Default bootstrap and confidence interval arguments are internally
#' defined and can be modified via `boot_args` and `ci_args`. User-supplied
#' values override defaults.
#'
#' @param impact_cube_data An impact cube object (class `"impact_cube"`)
#'   created with `create_impact_cube_data()`.
#' @param indicator Character string specifying the impact indicator to be
#'   computed. Options are `"overall"`, `"site"`, and `"species"`.
#' @param indicator_method Character string specifying the method used to
#'   compute the impact indicator (see methods in `compute_impact_indicator()`).
#' @param grouping_var A character vector specifying the grouping variable(s)
#'   for the bootstrap and confidence interval calculations. The function
#'   supplied to `bootstrap_cube()` must return one row per group. The specified
#'   variables must not be redundant (e.g., `"time_point"` and `"year"` should
#'   not both be used if one is simply an alternative encoding of the other).
#' @param ci_type Character string specifying the type of confidence interval
#'   to compute. Options include:
#'   - `"perc"`: Percentile interval (default)
#'   - `"bca"`: Bias-corrected and accelerated interval
#'   - `"norm"`: Normal approximation interval
#'   - `"basic"`: Basic bootstrap interval
#' @param confidence_level Numeric value specifying the confidence level for
#'   the intervals. Default is `0.95` (95% confidence level). This value is
#'   passed internally as `conf` to `calculate_bootstrap_ci()`.
#' @param boot_args Named list of additional arguments passed to
#'   `dubicube::bootstrap_cube()`. Defaults are:
#'   \describe{
#'     \item{samples}{Number of bootstrap replicates (default `1000`).}
#'     \item{seed}{Seed for reproducibility (default `NA`, meaning no call to `set.seed()`).}
#'   }
#'   User-supplied values override these defaults. Arguments that are
#'   internally defined in this function (e.g., `data_cube`, `fun`,
#'   `indicator_method`, `grouping_var`, `processed_cube`, `method`)
#'   must not be supplied via `boot_args`.
#' @param ci_args Named list of additional arguments passed to
#'   `dubicube::calculate_bootstrap_ci()`. Default is:
#'   \describe{
#'     \item{no_bias}{Logical; if `TRUE`, intervals are centered around the
#'     original estimates (bias is ignored).}
#'   }
#'   User-supplied values override defaults. The arguments `grouping_var`,
#'   `type`, and `conf` are controlled via `grouping_var`, `ci_type`, and
#'   `confidence_level`, respectively, and must not be supplied via `ci_args`.
#' @param out_var Character string specifying the column used for
#'   leave-one-out cross-validation. Default is `"taxonKey"`, which enables
#'   leave-one-species-out cross-validation.
#'
#' @return A named list with three components:
#' \describe{
#'   \item{bootstrap_params}{List of parameters for `dubicube::bootstrap_cube()`.}
#'   \item{ci_params}{List of parameters for `dubicube::calculate_bootstrap_ci()`.}
#'   \item{cv_params}{List of parameters for `dubicube::cross_validate_cube()`.}
#' }
#'
#' @export
#'
#' @examples
#' library(b3gbi)
#'
#' acacia_cube <- process_cube(
#'   cube_name = cube_acacia_SA,
#'   grid_type = "eqdgc",
#'   first_year = 2010,
#'   last_year = 2024
#' )
#'
#' impact_cube <- create_impact_cube_data(
#'   cube_data = acacia_cube,
#'   impact_data = eicat_acacia
#' )
#'
#' params <- prepare_indicators_bootstrap(
#'   impact_cube_data = impact_cube,
#'   indicator = "overall",
#'   indicator_method = "mean_cum",
#'   boot_args = list(samples = 2000),
#'   ci_args = list(no_bias = FALSE)
#' )
#'
#' # Bootstrap
#' bootstrap_results <- do.call(
#'   dubicube::bootstrap_cube,
#'   params$bootstrap_params
#' )
#'
#' # Confidence intervals
#' ci_result <- do.call(
#'   dubicube::calculate_bootstrap_ci,
#'   c(bootstrap_results = list(bootstrap_results), params$ci_params)
#' )
#'
#' # Cross-validation
#' cv_results <- do.call(
#'   dubicube::cross_validate_cube,
#'   params$cv_params
#' )
prepare_indicators_bootstrap <- function(
    impact_cube_data,
    indicator = c("overall", "site", "species"),
    indicator_method,
    grouping_var = "year",
    ci_type = "perc",
    confidence_level = 0.95,
    boot_args = list(samples = 1000, seed = NA),
    ci_args = list(no_bias = TRUE),
    out_var = "taxonKey") {
  # Check impact_cube_data
  if (!("impact_cube" %in% class(impact_cube_data))) {
    cli::cli_abort(c("{.var impact_cube_data} must be an impact cube object",
      "x" = "{.var impact_cube_data} is not a {.cls impact_cube}"
    ))
  }

  # Check type of indicator
  indicator <- match.arg(indicator)

  if (indicator %in% c("site", "species")) {
    cli::cli_abort("There is no method for indicator {indicator} currently")
  }

  # Defaults
  boot_defaults <- list(
    samples = 1000,
    seed = NA
  )
  ci_defaults <- list(
    no_bias = TRUE
  )

  # Merge user arguments
  boot_args <- utils::modifyList(boot_defaults, boot_args)
  ci_args   <- utils::modifyList(ci_defaults, ci_args)

  # Boot function for overall impact indicator
  boot_function <- function(impact_cube_data,
                            indicator_method) {
    if (indicator_method == "precaut") {
      impact_values <- compute_impact_indicators(impact_cube_data, "max", max)
    } else if (indicator_method == "precaut_cum") {
      impact_values <- compute_impact_indicators(impact_cube_data, "max", sum)
    } else if (indicator_method == "mean") {
      impact_values <- compute_impact_indicators(impact_cube_data, "mean", mean)
    } else if (indicator_method == "mean_cum") {
      impact_values <- compute_impact_indicators(impact_cube_data, "mean", sum)
    } else if (indicator_method == "cum") {
      impact_values <- compute_impact_indicators(impact_cube_data, "max_mech", sum)
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
  bootstrap_params <- c(
    list(
      data_cube = impact_cube_data,
      fun = boot_function,
      indicator_method = indicator_method,
      grouping_var = grouping_var,
      processed_cube = FALSE,
      method = "whole_cube"
    ),
    boot_args
  )

  # Confidence interval parameter
  ci_params <- c(
    list(
      grouping_var = grouping_var,
      type = ci_type,
      conf = confidence_level
    ),
    ci_args
  )

  # Cross-validation parameter
  cv_params <- list(
    data_cube = impact_cube_data,
    fun = boot_function,
    indicator_method = indicator_method,
    grouping_var = grouping_var,
    out_var = out_var,
    processed_cube = FALSE
  )

  return(
    list(
      bootstrap_params = bootstrap_params,
      ci_params = ci_params,
      cv_params = cv_params
    )
  )
}
