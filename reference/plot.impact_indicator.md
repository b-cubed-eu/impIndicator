# Plot overall impact indicator

Produces a `ggplot2` object showing the temporal trend of the overall
impact indicator.

## Usage

``` r
# S3 method for class 'impact_indicator'
plot(
  x,
  trend = c("none", "line", "smooth"),
  point_args = list(),
  errorbar_args = list(),
  trend_args = list(),
  ribbon_args = list(),
  ...
)
```

## Arguments

- x:

  An object of class `"impact_indicator"` as returned by
  [`compute_impact_indicator()`](https://b-cubed-eu.github.io/impIndicator/reference/compute_impact_indicator.md).

- trend:

  Character string indicating how the central trend should be displayed.
  One of:

  "none"

  :   No trend line is added.

  "line"

  :   A straight line connecting yearly values.

  "smooth"

  :   A loess-smoothed trend.

- point_args:

  A named list of arguments passed to
  [`ggplot2::geom_point()`](https://ggplot2.tidyverse.org/reference/geom_point.html)
  to customise the appearance of the yearly impact estimates (e.g.
  `size`, `colour`, `shape`).

- errorbar_args:

  A named list of arguments passed to
  [`ggplot2::geom_errorbar()`](https://ggplot2.tidyverse.org/reference/geom_linerange.html)
  to customise the uncertainty intervals, if lower (`ll`) and upper
  (`ul`) limits are available in `x$impact`.

- trend_args:

  A named list of arguments passed to the trend layer
  ([`ggplot2::geom_line()`](https://ggplot2.tidyverse.org/reference/geom_path.html)
  or
  [`ggplot2::geom_smooth()`](https://ggplot2.tidyverse.org/reference/geom_smooth.html),
  depending on `trend`) to customise its appearance (e.g. `colour`,
  `linewidth`, `linetype`, `alpha`).

- ribbon_args:

  A named list of arguments passed to
  [`ggplot2::geom_ribbon()`](https://ggplot2.tidyverse.org/reference/geom_ribbon.html)
  to customise the uncertainty ribbon, if lower (`ll`) and upper (`ul`)
  limits are available.

- ...:

  Currently not used.

## Value

A `ggplot` object representing the overall impact indicator over time,
with years on the x-axis and impact values on the y-axis.

## See also

Other Plot:
[`plot.site_impact()`](https://b-cubed-eu.github.io/impIndicator/reference/plot.site_impact.md),
[`plot.species_impact()`](https://b-cubed-eu.github.io/impIndicator/reference/plot.species_impact.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# create data_cube
acacia_cube <- taxa_cube(
  taxa = taxa_Acacia,
  region = southAfrica_sf,
  res = 0.25,
  first_year = 2010
)

# compute impact indicator
impact_value <- compute_impact_indicator(
  cube = acacia_cube,
  impact_data = eicat_acacia,
  method = "mean_cum",
  trans = 1
)

# default plot
plot(impact_value)

# customised plot
plot(
  impact_value,
  trend = "smooth",
  point_args = list(size = 3, colour = "darkred"),
  trend_args = list(colour = "black", linewidth = 1),
  ribbon_args = list(fill = "grey80", alpha = 0.3)
)
} # }
```
