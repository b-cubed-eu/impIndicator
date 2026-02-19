# Print an impact_indicator object

Provides a summary representation of an impact_indicator object,
designed for user-friendly display in the console.

## Usage

``` r
# S3 method for class 'impact_indicator'
print(x, n = 10, ...)
```

## Arguments

- x:

  An impact_indicator object.

- n:

  (Optional) Integer specifying the number of rows of data to display.

- ...:

  Additional arguments.

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

# print impact indicator
print(impact_value)
} # }
```
