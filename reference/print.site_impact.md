# Print an site_impact object

Provides a summary representation of an site_impact object, designed for
user-friendly display in the console.

## Usage

``` r
# S3 method for class 'site_impact'
print(x, n = 10, ...)
```

## Arguments

- x:

  An site_impact object.

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

siteImpact <- compute_impact_per_site(
  cube = acacia_cube,
  impact_data = eicat_acacia,
  method = "mean_cum",
  trans = 1
)

# print species impact
print(siteImpact)
#> Site impact indicator
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
#> # A tibble: 409 × 18
#>    cellCode xcoord ycoord `2010` `2011` `2012` `2013` `2014` `2015` `2016`
#>    <chr>     <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
#>  1 1110       29.9  -30.7   1.74  NA     NA     NA     NA     NA     NA   
#>  2 1376       30.4  -29.7   1.74  NA     NA     NA     NA     NA     NA   
#>  3 143        19.1  -34.2   3     NA      7.83   9.08  10.7    4.74  NA   
#>  4 206        18.4  -33.9   4.95   6.70   8.03  12.0   10.7    7.70  15.8 
#>  5 215        20.6  -33.9   1.74   1.74   1.74  NA      3.69   3.69  NA   
#>  6 668        18.4  -32.2   1.33  NA     NA     NA     NA     NA     NA   
#>  7 1312       30.9  -29.9  NA      1.95  NA     NA     NA     NA     NA   
#>  8 1375       30.1  -29.7  NA      1.74  NA      1.74  NA     NA     NA   
#>  9 144        19.4  -34.2  NA      1.95   1.74  NA     NA     NA     NA   
#> 10 209        19.1  -33.9  NA      1      1     NA     10.7   NA      1.95
#> # ℹ 399 more rows
#> # ℹ 8 more variables: `2017` <dbl>, `2018` <dbl>, `2019` <dbl>, `2020` <dbl>,
#> #   `2021` <dbl>, `2022` <dbl>, `2023` <dbl>, `2024` <dbl>
```
