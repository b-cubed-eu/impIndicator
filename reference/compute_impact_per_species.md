# Compute species impact indicator

Combines occurrences cube and impact data using the given method (e.g.,
mean, max) to compute the impact indicator per species. Optionally
computes bootstrap confidence intervals for the indicator grouped by
year and species.

Interval calculation is currently not implemented!

## Usage

``` r
compute_impact_per_species(
  cube,
  impact_data = NULL,
  method = NULL,
  trans = 1,
  ci_type = "none",
  confidence_level = 0.95,
  boot_args = list(samples = 1000, seed = NA),
  ci_args = list(no_bias = TRUE),
  col_category = NULL,
  col_species = NULL,
  col_mechanism = NULL,
  region = NULL
)
```

## Arguments

- cube:

  A data cube object (class `'processed_cube'` or `'sim_cube'`,
  processed from
  [`b3gbi::process_cube()`](https://b-cubed-eu.github.io/b3gbi/reference/process_cube.html))
  or a dataframe (cf. `$data` slot of `'processed_cube'` or
  `'sim_cube'`) or an impact cube (class `'impact_cube'` from
  [`create_impact_cube_data()`](https://b-cubed-eu.github.io/impIndicator/reference/create_impact_cube_data.md)).

- impact_data:

  A dataframe of species impact which contains columns of
  `impact_category`, `scientific_name` and `impact_mechanism`. Ignored
  if `cube` is already an `'impact_cube'`.

- method:

  A method of computing the indicator. The method used in the
  aggregation of within-species impact. The method can be:

  - `"max"`: The maximum method assigns a species the maximum impact
    across all records of the species. It is best for precautionary
    approaches. However, it can overestimate the impact of a species if
    the highest impact requires rare or specific conditions.

  - `"mean"`: Assigns a species the mean impact across all its impact
    records. This method computes the expected impact of the species and
    is adequate when many impact records are available.

  - `"max_mech"`: Assigns a species the summation of the maximum impact
    per mechanism. This assumes species with multiple mechanisms of
    impact have higher potential to cause impact.

- trans:

  Numeric: `1` (default), `2` or `3`. The method of transformation to
  convert the EICAT categories `c("MC", "MN", "MO", "MR", "MV")` to
  numerical values:

  - `1`: converts the categories to `c(0, 1, 2, 3, 4)`

  - `2`: converts the categories to `c(1, 2, 3, 4, 5)`

  - `3`: converts the categories to `c(1, 10, 100, 1000, 10000)`

- ci_type:

  A character string specifying the type of confidence intervals to
  compute. Options include:

  - `"perc"`: Percentile intervals (default).

  - `"bca"`: Bias-corrected and accelerated intervals.

  - `"norm"`: Normal approximation intervals.

  - `"basic"`: Basic bootstrap intervals.

  - `"none"`: No confidence intervals calculated.

- confidence_level:

  The confidence level for the calculated intervals. Default is `0.95`
  (95% confidence level).

- boot_args:

  (Optional) Named list of additional arguments passed to
  [`dubicube::bootstrap_cube()`](https://b-cubed-eu.github.io/dubicube/reference/bootstrap_cube.html).
  Default: `list(samples = 1000, seed = NA)`.

- ci_args:

  (Optional) Named list of additional arguments passed to
  [`dubicube::calculate_bootstrap_ci()`](https://b-cubed-eu.github.io/dubicube/reference/calculate_bootstrap_ci.html).
  Default: `list(no_bias = TRUE)`.

- col_category:

  The name of the column containing the impact categories. The first two
  letters of each category must be an EICAT short name (e.g.,
  `"MC - Minimal concern"`).

- col_species:

  The name of the column containing species names.

- col_mechanism:

  The name of the column containing mechanisms of impact.

- region:

  The shape file of the specific region to calculate the indicator on.
  If `NULL` (default), the indicator is calculated for all cells in the
  cube.

## Value

A list of class `'species_impact'`, with the following components:

- `method`: Method used in computing the indicator.

- `num_species`: Number of species in the indicator.

- `names_species`: Names of species in the indicator.

- `species_impact`: A dataframe containing impact per species and year.

## See also

Other Indicator function:
[`compute_impact_indicator()`](https://b-cubed-eu.github.io/impIndicator/reference/compute_impact_indicator.md),
[`compute_impact_per_site()`](https://b-cubed-eu.github.io/impIndicator/reference/compute_impact_per_site.md)

## Examples

``` r
acacia_cube <- taxa_cube(
  taxa = taxa_Acacia,
  region = southAfrica_sf,
  res = 0.25,
  first_year = 2010
)

# Without confidence intervals
speciesImpact <- compute_impact_per_species(
  cube = acacia_cube,
  impact_data = eicat_acacia,
  method = "mean",
  trans = 1
)
```
