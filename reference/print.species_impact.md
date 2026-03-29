# Print an species_impact object

Provides a summary representation of an species_impact object, designed
for user-friendly display in the console.

## Usage

``` r
# S3 method for class 'species_impact'
print(x, n = 10, ...)
```

## Arguments

- x:

  An species_impact object.

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

# compute species impact
speciesImpact <- compute_species_indicator(
  cube = acacia_cube,
  impact_data = eicat_acacia,
  method = "mean",
  trans = 1
)

# print species impact
print(speciesImpact)
#> Species impact indicator
#> 
#> Method: mean 
#> 
#> Number of species: 10 
#> 
#> 
#> First 10 rows of data (use n = to show more):
#> 
#> # A tibble: 15 × 11
#>     year `Acacia baileyana` `Acacia cyclops` `Acacia dealbata`
#>    <dbl>              <dbl>            <dbl>             <dbl>
#>  1  2010                 NA             1.33             NA   
#>  2  2011                 NA            NA                NA   
#>  3  2012                  6            14.7              NA   
#>  4  2013                  9            16                 3.48
#>  5  2014                  9            14.7              NA   
#>  6  2015                 NA            10.7               8.70
#>  7  2016                  3            16                15.7 
#>  8  2017                  3            20                 8.70
#>  9  2018                  3            26.7               6.96
#> 10  2019                 30            62.7              27.8 
#> # ℹ 5 more rows
#> # ℹ 7 more variables: `Acacia decurrens` <dbl>, `Acacia elata` <dbl>,
#> #   `Acacia longifolia` <dbl>, `Acacia mearnsii` <dbl>,
#> #   `Acacia melanoxylon` <dbl>, `Acacia pycnantha` <dbl>,
#> #   `Acacia saligna` <dbl>
```
