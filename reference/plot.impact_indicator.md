# Plot overall impact indicator

Produces a ggplot object to show the trend of the overall impact
indicator.

## Usage

``` r
# S3 method for class 'impact_indicator'
plot(
  x,
  linewidth = 2,
  colour = "red",
  title_lab = "Overall impact indicator",
  y_lab = "Impact value",
  x_lab = "Year",
  text_size = 14,
  ...
)
```

## Arguments

- x:

  A dataframe of impact indicator. Must be a class of "impact_indicator"

- linewidth:

  The width size of the line. Default is 2

- colour:

  The colour of the line Default is "red"

- title_lab:

  Title of the plot. Default is "Impact indicator"

- y_lab:

  Label of the y-axis. Default is "Impact score"

- x_lab:

  Label of the x-axis. Default is "Year"

- text_size:

  The size of the text of the plot. Default is "14"

- ...:

  Additional arguments passed to geom_line

## Value

The ggplot object of the impact indicator, with the y- and x-axes
representing the impact score and time respectively.

## See also

Other Plot:
[`plot.site_impact()`](https://b-cubed-eu.github.io/impIndicator/reference/plot.site_impact.md),
[`plot.species_impact()`](https://b-cubed-eu.github.io/impIndicator/reference/plot.species_impact.md)

## Examples

``` r
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

# plot impact indicator
plot(impact_value)
```
