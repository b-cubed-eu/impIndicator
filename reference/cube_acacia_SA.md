# GBIF Occurrence Cube of acacia in South Africa An example of occurrence cube of GBIF containing required column for impact indicator.

GBIF Occurrence Cube of acacia in South Africa An example of occurrence
cube of GBIF containing required column for impact indicator.

## Usage

``` r
cube_acacia_SA
```

## Format

A dataframe object containing 4,700 rows and 8 variables

- year:

  The year the occurrence was recorded

- eqdcellcode:

  The extended quarter degree cell code

- speciesKey:

  The GBIF species identification number

- species:

  The scientific name of species

- occurrences:

  The number of observation in the cell

- kingdom:

  The kingdom name of which the species belong

- family:

  The family name of which the species belong

- mincoordinateuncertaintyinmeters:

  minimum radius of the uncertainty circle around the geographic point

## Source

GBIF.org (16 October 2025) GBIF Occurrence Download
[doi:10.15468/dl.zm3keb](https://doi.org/10.15468/dl.zm3keb)

## See also

Other Data:
[`eicat_acacia`](https://b-cubed-eu.github.io/impIndicator/reference/eicat_acacia.md),
[`southAfrica_sf`](https://b-cubed-eu.github.io/impIndicator/reference/southAfrica_sf.md),
[`taxa_Acacia`](https://b-cubed-eu.github.io/impIndicator/reference/taxa_Acacia.md)

## Examples

``` r
head(cube_acacia_SA, 10)
#>    year eqdcellcode specieskey        species occurrences kingdom   family
#> 1  2012   E008S28AC    2978552 Acacia saligna           1 Plantae Fabaceae
#> 2  2021   E016S28BD    2980425 Acacia cyclops           1 Plantae Fabaceae
#> 3  1995   E016S28CB    2980425 Acacia cyclops           1 Plantae Fabaceae
#> 4  2021   E016S28DA    2980425 Acacia cyclops           1 Plantae Fabaceae
#> 5  2024   E016S28DA    2980425 Acacia cyclops           1 Plantae Fabaceae
#> 6  2013   E016S29BD    2980425 Acacia cyclops           1 Plantae Fabaceae
#> 7  2023   E017S29AA    2980425 Acacia cyclops           1 Plantae Fabaceae
#> 8  2025   E017S29BD    2980425 Acacia cyclops           1 Plantae Fabaceae
#> 9  2018   E017S29CA    2978552 Acacia saligna           1 Plantae Fabaceae
#> 10 2025   E017S29DB    2978552 Acacia saligna           1 Plantae Fabaceae
#>    mincoordinateuncertaintyinmeters
#> 1                           1575268
#> 2                                19
#> 3                              1000
#> 4                                31
#> 5                              1000
#> 6                                 1
#> 7                                 1
#> 8                                 2
#> 9                                 7
#> 10                                4
```
