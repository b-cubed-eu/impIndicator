# Overall impact indicator

Combines occurrences cube and impact data using the given method (e.g.,
mean cumulative) to compute the impact indicator of all species over a
given region

## Usage

``` r
compute_impact_indicator(
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
  aggregation of within and across species in a site proposed by
  Boulesnane-Genguant et al. (submitted). The method can be one of

  - `"precaut"`: The "`precautionary`" method assigns a species the
    maximum impact across all records of the species and then compute
    the maximum impact across species in each site

  - `"precaut_cum"`: The "`precautionary cumulative`" method assigns a
    species the maximum impact across all records of the species then
    compute the summation of all impacts in each site. The precautionary
    cumulative method provides the highest impact score possible for
    each species but considers the number of co-occurring species in
    each site.

  - `"mean"`:The "`mean`" method assigns species the mean impact of all
    the species impact and then computes the mean of all species in each
    site. The mean provides the expected impact within individual
    species and across all species in each site.

  - `"mean_cum"`: The "`mean cumulative`" assigns a species the mean
    impact of all the species impact and then computes the summation of
    all impact scores in each site. The mean cumulative provides the
    expected impact score within individual species but adds
    co-occurring species’ impact scores in each site.

  - `"cum"`: The "`cumulative`" assigns a species the summation of the
    maximum impact per mechanism and then computes the summation of all
    species’ impacts per site. The cumulative method provides a
    comprehensive view of the overall impact while considering the
    impact and mechanisms of multiple species.

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

A list of class `impact_indicator`, with the following components:

- `method`: method used in computing the indicator

- `num_cells`: number of cells (sites) in the indicator

- `num_species`: number of species in the indicator

- `names_species`: names of species in the indicator

- `site_impact`: a dataframe containing total species impact per year

## See also

Other Indicator function:
[`compute_impact_per_site()`](https://b-cubed-eu.github.io/impIndicator/reference/compute_impact_per_site.md),
[`compute_impact_per_species()`](https://b-cubed-eu.github.io/impIndicator/reference/compute_impact_per_species.md)

## Examples

``` r
acacia_cube <- taxa_cube(
  taxa = taxa_Acacia,
  region = southAfrica_sf,
  res = 0.25,
  first_year = 2010
)
impact_value <- compute_impact_indicator(
  cube = acacia_cube,
  impact_data = eicat_acacia,
  method = "mean_cum",
  trans = 1
)
```
