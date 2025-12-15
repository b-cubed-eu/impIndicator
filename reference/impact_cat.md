# Impact categories

Aggregate species impact categories from impact data. Species are often
reported to have multiple impact categories specific to different study
locations and mechanisms through which they exert the impact. To get an
estimate of a likely impact category which could apply more broadly,
this function aggregate the multiple impact scores per species into one
impact score per species.

## Usage

``` r
impact_cat(
  impact_data,
  species_list,
  trans = 1,
  col_category = NULL,
  col_species = NULL,
  col_mechanism = NULL
)
```

## Arguments

- impact_data:

  The dataframe of species impact which contains columns of
  `impact_category`, `scientific_name` and `impact_mechanism`.

- species_list:

  The vector of species' list to aggregate their impact categories.

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

The dataframe containing the aggregated species impact. max - maximum
impact of a species. mean - mean impact of a species. max_mech - sum of
maximum impact per categories of a species

## See also

Other Prepare data:
[`taxa_cube()`](https://b-cubed-eu.github.io/impIndicator/reference/taxa_cube.md)

## Examples

``` r
# define species list
species_list <- c(
  "Acacia adunca",
  "Acacia baileyana",
  "Acacia binervata",
  "Acacia crassiuscula",
  "Acacia cultriformis",
  "Acacia cyclops",
  "Acacia dealbata",
  "Acacia decurrens",
  "Acacia elata"
)

agg_impact <- impact_cat(
  impact_data = eicat_acacia,
  species_list = species_list,
  trans = 1
)
```
