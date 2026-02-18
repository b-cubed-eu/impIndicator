#' Compute species impact indicator
#'
#' @description
#' Combines occurrences cube and impact data using the given method
#' (e.g., mean, max) to compute the impact indicator per species.
#' Optionally computes bootstrap confidence intervals for the indicator
#' grouped by year and species.
#'
#' @param cube A data cube object (class `'processed_cube'` or `'sim_cube'`,
#' processed from `b3gbi::process_cube()`) or a dataframe (cf. `$data` slot of
#' `'processed_cube'` or `'sim_cube'`) or an impact cube (class `'impact_cube'`
#' from `create_impact_cube_data()`).
#' @param impact_data A dataframe of species impact which contains columns of
#' `impact_category`, `scientific_name` and `impact_mechanism`.
#' Ignored if `cube` is already an `'impact_cube'`.
#' @param method A method of computing the indicator.
#' The method used in the aggregation of within-species impact.
#' The method can be:
#'   - `"max"`: The maximum method assigns a species the maximum impact
#'   across all records of the species. It is best for precautionary
#'   approaches. However, it can overestimate the impact of a species
#'   if the highest impact requires rare or specific conditions.
#'   - `"mean"`: Assigns a species the mean impact across all its
#'   impact records. This method computes the expected impact of
#'   the species and is adequate when many impact records are available.
#'   - `"max_mech"`: Assigns a species the summation of the maximum
#'   impact per mechanism. This assumes species with multiple mechanisms
#'   of impact have higher potential to cause impact.
#' @param trans Numeric: `1` (default), `2` or `3`. The method of transformation
#' to convert the EICAT categories `c("MC", "MN", "MO", "MR", "MV")`
#' to numerical values:
#'   - `1`: converts the categories to `c(0, 1, 2, 3, 4)`
#'   - `2`: converts the categories to `c(1, 2, 3, 4, 5)`
#'   - `3`: converts the categories to `c(1, 10, 100, 1000, 10000)`
#' @param ci_type A character string specifying the type of confidence
#' intervals to compute. Options include:
#'   * `"perc"`: Percentile intervals (default).
#'   * `"bca"`: Bias-corrected and accelerated intervals.
#'   * `"norm"`: Normal approximation intervals.
#'   * `"basic"`: Basic bootstrap intervals.
#'   * `"none"`: No confidence intervals calculated.
#' @param confidence_level The confidence level for the calculated
#' intervals. Default is `0.95` (95% confidence level).
#' @param boot_args (Optional) Named list of additional arguments passed to
#' `dubicube::bootstrap_cube()`.
#' Default: `list(samples = 1000, seed = NA)`.
#' @param ci_args (Optional) Named list of additional arguments passed to
#' `dubicube::calculate_bootstrap_ci()`.
#' Default: `list(no_bias = TRUE)`.
#' @param col_category The name of the column containing the impact categories.
#' The first two letters of each category must be an EICAT short name
#' (e.g., `"MC - Minimal concern"`).
#' @param col_species The name of the column containing species names.
#' @param col_mechanism The name of the column containing mechanisms of impact.
#' @param region The shape file of the specific region to calculate
#' the indicator on. If `NULL` (default), the indicator is calculated
#' for all cells in the cube.
#'
#' @return A list of class `'species_impact'`, with the following components:
#'   - `method`: Method used in computing the indicator.
#'   - `num_species`: Number of species in the indicator.
#'   - `names_species`: Names of species in the indicator.
#'   - `species_impact`: A dataframe containing impact per species and year.
#'     If `ci_type != "none"`, this dataframe additionally contains
#'     confidence interval columns.
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
#'
#' # Without confidence intervals
#' speciesImpact <- compute_impact_per_species(
#'   cube = acacia_cube,
#'   impact_data = eicat_acacia,
#'   method = "mean",
#'   trans = 1,
#'   ci_type = "none"
#' )
#'
#' # With bootstrap confidence intervals
#' speciesImpactCI <- compute_impact_per_species(
#'   cube = acacia_cube,
#'   impact_data = eicat_acacia,
#'   method = "mean",
#'   trans = 1,
#'   ci_type = "perc",
#'   confidence_level = 0.95
#' )

compute_impact_per_species <- function(
    cube,
    impact_data = NULL,
    method = NULL,
    trans = 1,
    ci_type = c("perc", "bca", "norm", "basic", "none"),
    confidence_level = 0.95,
    boot_args = list(samples = 1000, seed = NA),
    ci_args = list(no_bias = TRUE),
    col_category = NULL,
    col_species = NULL,
    col_mechanism = NULL,
    region = NULL) {
  # avoid "no visible binding for global variable" NOTE for the following names
  taxonKey <- year <- cellCode <- max_mech <- scientificName <- NULL
  # check arguments
  if ("sim_cube" %in% class(cube) || "processed_cube" %in% class(cube)){
    cube <- cube$data
  } else if ( "data.frame" %in% class(cube)){
    cube <- cube
  } else {
    cli::cli_abort(
      c("{.var cube} must be a class {.cls data.frame}, {.cls sim_cube} or {.cls processed_cube}",
        "i" = "cube must be processed from `b3gbi`")
    )

  }

  # region is NULL or an sf
  if (!(is.null(region) || "sf" %in% class(region))) {
    cli::cli_abort(
      c("{.var region} is not a class {.cls sf}",
        "i" = "{.var region} must be a class {.cls sf} if provided")
    )
  }

  ci_type <- match.arg(ci_type, c("perc", "bca", "norm", "basic", "none"))

  # Create impact cube data if the cube is not have impact data
  if (!("impact_cube" %in% class(cube))){
    # merge occurrence cube and impact data
    impact_cube_data <- create_impact_cube_data(
      cube_data = cube,
      impact_data = impact_data,
      trans = trans,
      col_category = col_category,
      col_species = col_species,
      col_mechanism = col_mechanism,
      region = region
    )
  } else {
    impact_cube_data <- cube
    if (!(is.null(impact_data))) {
      cli::cli_alert_warning(
        "{.var cube} contains impact data. The {.var impact_data} was not used"
      )
    }
  }

  # collect the number and names of species in the impact indicator
  num_of_species <- length(unique(impact_cube_data$scientificName))
  names_of_species <- sort(unique(impact_cube_data$scientificName))

  if (ci_type != "none") {
    stop("Confidence interval calculation not implemented yet.")

    params <- prepare_indicators_bootstrap(
      impact_cube_data = impact_cube_data,
      indicator = "species",
      indicator_method = method,
      ci_type = ci_type,
      confidence_level = confidence_level,
      boot_args = boot_args,
      ci_args = ci_args,
      grouping_var = c("year", "scientificName")
    )

    bootstrap_results <- do.call(
      dubicube::bootstrap_cube,
      params$bootstrap_params
    )

    ci_result <- do.call(
      dubicube::calculate_bootstrap_ci,
      c(
        bootstrap_results = list(bootstrap_results),
        params$ci_params
      )
    )

    species_values <- ci_result %>%
      tibble::as_tibble() %>%
      dplyr::select(!dplyr::all_of(c("int_type", "conf"))) %>%
      dplyr::rename("impact_val" = "est_original")

  } else {
    if (!method %in% c("max", "mean", "max_mech")) {
      cli::cli_abort(
        "{.var method} should be one of max, mean or max_mech options"
      )
    }

    species_values <- compute_species_impact(impact_cube_data, method)
    species_values <- tibble::as_tibble(species_values)
  }

  structure(list(method = method,
                 num_species = num_of_species,
                 names_species = names_of_species,
                 species_impact = species_values),
            class = "species_impact")
}
