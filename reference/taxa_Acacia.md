# GBIF occurrences data of acacia in South Africa An example of occurrence data from GBIF containing required column for impact indicator.

GBIF occurrences data of acacia in South Africa An example of occurrence
data from GBIF containing required column for impact indicator.

## Usage

``` r
taxa_Acacia
```

## Format

A dataframe object containing 19,100 rows and 6 variables

- decimalLatitude:

  geographic latitude in decimal

- decimalLongitude:

  geographic longitude in decimal

- species:

  scientific name of species

- speciesKey:

  GBIF species identification number

- coordinateUncertaintyInMeters:

  radius of the uncertainty circle around geographic point

- year:

  year occurrence was recorded

## Source

[doi:10.15468/dl.b6gda5](https://doi.org/10.15468/dl.b6gda5)

## See also

Other Data:
[`cube_acacia_SA`](https://b-cubed-eu.github.io/impIndicator/reference/cube_acacia_SA.md),
[`eicat_acacia`](https://b-cubed-eu.github.io/impIndicator/reference/eicat_acacia.md),
[`southAfrica_sf`](https://b-cubed-eu.github.io/impIndicator/reference/southAfrica_sf.md)

## Examples

``` r
head(taxa_Acacia, 10)
#> # A tibble: 10 × 6
#>    decimalLatitude decimalLongitude species    speciesKey coordinateUncertaint…¹
#>              <dbl>            <dbl> <chr>           <dbl>                  <dbl>
#>  1           -33.5             26.3 Acacia me…    2979775                     25
#>  2           -32.3             19.0 Acacia me…    2979775                      8
#>  3           -34.6             19.8 Acacia lo…    2978730                      5
#>  4           -34.7             19.8 Acacia cy…    2980425                     NA
#>  5           -34.4             19.2 Acacia lo…    2978730                     15
#>  6           -33.0             18.4 Acacia sa…    2978552                      4
#>  7           -33.7             18.7 Acacia sa…    2978552                     15
#>  8           -34.3             19.0 Acacia lo…    2978730                      4
#>  9           -26.2             28.1 Acacia me…    2979775                      9
#> 10           -34.4             19.9 Acacia cy…    2980425                     15
#> # ℹ abbreviated name: ¹​coordinateUncertaintyInMeters
#> # ℹ 1 more variable: year <dbl>
```
