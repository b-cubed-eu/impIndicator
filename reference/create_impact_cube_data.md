# Create impact cube data

This function combines the occurrence cube data and impact data, named
impact_cube_data.

## Usage

``` r
create_impact_cube_data(
  cube_data,
  impact_data,
  trans = 1,
  col_category = NULL,
  col_species = NULL,
  col_mechanism = NULL,
  region = NULL
)
```

## Arguments

- cube_data:

  A dataframe of a cube ( \$data slot) of class `sim_cube` or
  `processed_cube` from
  [`b3gbi::process_cube()`](https://b-cubed-eu.github.io/b3gbi/reference/process_cube.html).

- impact_data:

  The dataframe of species impact which contains columns of
  `impact_category`, `scientific_name` and `impact_mechanism`.

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

- region:

  The shape file of the specific region to calculate the indicator on.
  If NULL (default), the indicator is calculated for all cells in the
  cube.

## Value

A dataframe of containing impact data and occurrence cube. The class is
`impact_cube`

## Examples

``` r
library(b3gbi) # for processing cube
acacia_cube <- process_cube(cube_name = cube_acacia_SA,
                          grid_type = "eqdgc",
                          first_year = 2010,
                           last_year = 2024)

impact_cube <- create_impact_cube_data(
  cube_data = acacia_cube$data,
  impact_data = eicat_acacia,
)
```
