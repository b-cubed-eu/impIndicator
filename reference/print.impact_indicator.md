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
#> Overall impact indicator
#> 
#> Method: mean_cum 
#> 
#> Number of cells: 409 
#> 
#> Number of species: 10 
#> 
#> 
#> First 10 rows of data (use n = to show more):
#> 
#> # A tibble: 15 × 2
#>     year diversity_val
#>    <dbl>         <dbl>
#>  1  2010        0.0354
#>  2  2011        0.0518
#>  3  2012        0.197 
#>  4  2013        0.279 
#>  5  2014        0.374 
#>  6  2015        0.354 
#>  7  2016        0.359 
#>  8  2017        0.415 
#>  9  2018        0.459 
#> 10  2019        1.16  
#> # ℹ 5 more rows
```
