# Compute species impact indicator

Combines occurrences cube and impact data using the given method (e.g.,
mean) to compute the impact indicator per species.

## Usage

``` r
compute_impact_per_species(
  cube,
  impact_data = NULL,
  method = NULL,
  trans = 1,
  col_category = NULL,
  col_species = NULL,
  col_mechanism = NULL
)
```

## Arguments

- cube:

  The data cube of class `sim_cube` or `processed_cube` from
  [`b3gbi::process_cube()`](https://b-cubed-eu.github.io/b3gbi/reference/process_cube.html).

- impact_data:

  The dataframe of species impact which contains columns of
  `impact_category`, `scientific_name` and `impact_mechanism`.

- method:

  The method of computing the indicator. The method used in the
  aggregation of within impact of species. The method can be

  - `"max"`:The maximum method assigns a species the maximum impact
    across all records of the species. It is best for precautionary
    approaches. Also, the assumption is that the management of the
    highest impact can cover for the lower impact caused by a species
    and can be the best when there is low confidence in the multiple
    impacts of species of interest. However, the maximum method can
    overestimate the impact of a species especially when the highest
    impact requires specific or rare conditions and many lower impacts
    were recorded.

  - `"mean"`: assigns a species the mean impact of all the species
    impact. This method computes the expected impact of the species
    considering all species impact without differentiating between
    impacts. This method is adequate when there are many impact records
    per species.

  - `"max_mech"`: Assigns a species the summation of the maximum impact
    per mechanism. The assumption is that species with many mechanisms
    of impact have a higher potential to cause impact.

- trans:

  Numeric: `1` (default), `2` or `3`. The method of transformation to
  convert the EICAT categories `c("MC", "MN", "MO", "MR", "MV")` to
  numerical values:

  - `1`: converts the categories to `c(0, 1, 2, 3, 4)`

  - `2`: converts the categories to to `c(1, 2, 3, 4, 5)`

  - `3`: converts the categories to to `c(1, 10, 100, 1000, 10000)`

- col_category:

  The name of the column containing the impact categories. The first two
  letters each categories must be an EICAT short names (e.g "MC -
  Minimal concern").

- col_species:

  The name of the column containing species names.

- col_mechanism:

  The name of the column containing mechanisms of impact.

## Value

A list of class `species_impact`, with the following components:

- `method`: method used in computing the indicator

- `num_species`: number of species in the indicator

- `names_species`: names of species in the indicator

- `species_impact`: a dataframe containing impact per species

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

speciesImpact <- compute_impact_per_species(
  cube = acacia_cube,
  impact_data = eicat_acacia,
  method = "mean",
  trans = 1
)
```
