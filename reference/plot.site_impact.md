# Plot site impact

Produces the ggplot of site impact indicator

## Usage

``` r
# S3 method for class 'site_impact'
plot(
  x,
  region = NULL,
  first_year = NULL,
  last_year = NULL,
  title_lab = "Site Impact map",
  text_size = 14,
  ...
)
```

## Arguments

- x:

  A dataframe of impact indicator. Must be a class of "site_impact"

- region:

  sf or character. The shapefile of the region of study or a character
  which represent the name of a country. It is not compulsory but makes
  the plot more comprehensible.

- first_year:

  The first year the impact map should include. Default starts from the
  first year included in `x`.

- last_year:

  The last year the impact map should include. Default ends in the last
  year included in `x`.

- title_lab:

  Title of the plot. Default is "Impact map"

- text_size:

  The size of the text of the plot. Default is "14"

- ...:

  Additional arguments passed to geom_tile

## Value

The ggplot of species yearly impact on the region.

## See also

Other Plot:
[`plot.impact_indicator()`](https://b-cubed-eu.github.io/impIndicator/reference/plot.impact_indicator.md),
[`plot.species_impact()`](https://b-cubed-eu.github.io/impIndicator/reference/plot.species_impact.md)

## Examples

``` r
# define cube for taxa
acacia_cube <- taxa_cube(
  taxa = taxa_Acacia,
  region = southAfrica_sf,
  res = 0.25,
  first_year = 2010
)

# compute site impact
siteImpact <- compute_impact_per_site(
  cube = acacia_cube,
  impact_data = eicat_acacia,
  method = "mean_cum",
  trans = 1

)

# visualise site impact
plot(x = siteImpact, region = southAfrica_sf, first_year = 2021)
```
