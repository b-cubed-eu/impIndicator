# Prepare indicators for bootstrap and cross validation

Create the parameter lists required to perform bootstrapping
([`dubicube::bootstrap_cube()`](https://b-cubed-eu.github.io/dubicube/reference/bootstrap_cube.html)),
calculate confidence intervals
([`dubicube::calculate_bootstrap_ci()`](https://b-cubed-eu.github.io/dubicube/reference/calculate_bootstrap_ci.html)),
and perform cross-validation
([`dubicube::cross_validate_cube()`](https://b-cubed-eu.github.io/dubicube/reference/cross_validate_cube.html)).

This function is primarily intended for internal use by indicator
functions, but can also be used directly to construct parameter lists
for manual calls to the underlying `dubicube` functions.

Default bootstrap and confidence interval arguments are internally
defined and can be modified via `boot_args` and `ci_args`. User-supplied
values override defaults.

## Usage

``` r
prepare_indicators_bootstrap(
  impact_cube_data,
  indicator = c("overall", "site", "species"),
  indicator_method,
  grouping_var = "year",
  ci_type = "perc",
  confidence_level = 0.95,
  boot_args = list(samples = 1000, seed = NA),
  ci_args = list(no_bias = TRUE),
  out_var = "taxonKey"
)
```

## Arguments

- impact_cube_data:

  An impact cube object (class `"impact_cube"`) created with
  [`create_impact_cube_data()`](https://b-cubed-eu.github.io/impIndicator/reference/create_impact_cube_data.md).

- indicator:

  Character string specifying the impact indicator to be computed.
  Options are `"overall"`, `"site"`, and `"species"`.

- indicator_method:

  Character string specifying the method used to compute the impact
  indicator (see methods in
  [`compute_impact_indicator()`](https://b-cubed-eu.github.io/impIndicator/reference/compute_impact_indicator.md)).

- grouping_var:

  A character vector specifying the grouping variable(s) for the
  bootstrap and confidence interval calculations. The function supplied
  to
  [`bootstrap_cube()`](https://b-cubed-eu.github.io/dubicube/reference/bootstrap_cube.html)
  must return one row per group. The specified variables must not be
  redundant (e.g., `"time_point"` and `"year"` should not both be used
  if one is simply an alternative encoding of the other).

- ci_type:

  Character string specifying the type of confidence interval to
  compute. Options include:

  - `"perc"`: Percentile interval (default)

  - `"bca"`: Bias-corrected and accelerated interval

  - `"norm"`: Normal approximation interval

  - `"basic"`: Basic bootstrap interval

- confidence_level:

  Numeric value specifying the confidence level for the intervals.
  Default is `0.95` (95% confidence level). This value is passed
  internally as `conf` to
  [`calculate_bootstrap_ci()`](https://b-cubed-eu.github.io/dubicube/reference/calculate_bootstrap_ci.html).

- boot_args:

  Named list of additional arguments passed to
  [`dubicube::bootstrap_cube()`](https://b-cubed-eu.github.io/dubicube/reference/bootstrap_cube.html).
  Defaults are:

  samples

  :   Number of bootstrap replicates (default `1000`).

  seed

  :   Seed for reproducibility (default `NA`, meaning no call to
      [`set.seed()`](https://rdrr.io/r/base/Random.html)).

  User-supplied values override these defaults. Arguments that are
  internally defined in this function (e.g., `data_cube`, `fun`,
  `indicator_method`, `grouping_var`, `processed_cube`, `method`) must
  not be supplied via `boot_args`.

- ci_args:

  Named list of additional arguments passed to
  [`dubicube::calculate_bootstrap_ci()`](https://b-cubed-eu.github.io/dubicube/reference/calculate_bootstrap_ci.html).
  Default is:

  no_bias

  :   Logical; if `TRUE`, intervals are centered around the original
      estimates (bias is ignored).

  User-supplied values override defaults. The arguments `grouping_var`,
  `type`, and `conf` are controlled via `grouping_var`, `ci_type`, and
  `confidence_level`, respectively, and must not be supplied via
  `ci_args`.

- out_var:

  Character string specifying the column used for leave-one-out
  cross-validation. Default is `"taxonKey"`, which enables
  leave-one-species-out cross-validation.

## Value

A named list with three components:

- bootstrap_params:

  List of parameters for
  [`dubicube::bootstrap_cube()`](https://b-cubed-eu.github.io/dubicube/reference/bootstrap_cube.html).

- ci_params:

  List of parameters for
  [`dubicube::calculate_bootstrap_ci()`](https://b-cubed-eu.github.io/dubicube/reference/calculate_bootstrap_ci.html).

- cv_params:

  List of parameters for
  [`dubicube::cross_validate_cube()`](https://b-cubed-eu.github.io/dubicube/reference/cross_validate_cube.html).

## Examples

``` r
if (FALSE) { # \dontrun{
library(b3gbi)

acacia_cube <- process_cube(
  cube_name = cube_acacia_SA,
  grid_type = "eqdgc",
  first_year = 2010,
  last_year = 2024
)

impact_cube <- create_impact_cube_data(
  cube_data = acacia_cube,
  impact_data = eicat_acacia
)

params <- prepare_indicators_bootstrap(
  impact_cube_data = impact_cube,
  indicator = "overall",
  indicator_method = "mean_cum",
  boot_args = list(samples = 2000),
  ci_args = list(no_bias = FALSE)
)

# Bootstrap
bootstrap_results <- do.call(
  dubicube::bootstrap_cube,
  params$bootstrap_params
)

# Confidence intervals
ci_result <- do.call(
  dubicube::calculate_bootstrap_ci,
  c(bootstrap_results = list(bootstrap_results), params$ci_params)
)

# Cross-validation
cv_results <- do.call(
  dubicube::cross_validate_cube,
  params$cv_params
)
} # }
```
