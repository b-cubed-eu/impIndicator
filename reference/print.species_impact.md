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
speciesImpact <- compute_impact_per_species(
  cube = acacia_cube,
  impact_data = eicat_acacia,
  method = "mean",
  trans = 1
)

# print species impact
print(speciesImpact)
#> Site impact indicator
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
#>  1  2010           NA                0.00326          NA      
#>  2  2011           NA               NA                NA      
#>  3  2012            0.0147           0.0359           NA      
#>  4  2013            0.0220           0.0391            0.00850
#>  5  2014            0.0220           0.0359           NA      
#>  6  2015           NA                0.0261            0.0213 
#>  7  2016            0.00733          0.0391            0.0383 
#>  8  2017            0.00733          0.0489            0.0213 
#>  9  2018            0.00733          0.0652            0.0170 
#> 10  2019            0.0733           0.153             0.0680 
#> # ℹ 5 more rows
#> # ℹ 7 more variables: `Acacia decurrens` <dbl>, `Acacia elata` <dbl>,
#> #   `Acacia longifolia` <dbl>, `Acacia mearnsii` <dbl>,
#> #   `Acacia melanoxylon` <dbl>, `Acacia pycnantha` <dbl>,
#> #   `Acacia saligna` <dbl>
```
