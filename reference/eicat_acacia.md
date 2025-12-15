# EICAT data of acacia taxa An example of EICAT data containing species name, impact category and mechanism.

EICAT data of acacia taxa An example of EICAT data containing species
name, impact category and mechanism.

## Usage

``` r
eicat_acacia
```

## Format

A dataframe object containing 138 observations and 3 variables

- scientific_name:

  species scientific name

- impact_category:

  EICAT impact category

- impact_mechanism:

  mechanism of impact

## Source

Jansen, C., Kumschick, S. A global impact assessment of Acacia species
introduced to South Africa. Biol Invasions 24, 175–187 (2022).
[doi:10.1007/s10530-021-02642-0](https://doi.org/10.1007/s10530-021-02642-0)

## See also

Other Data:
[`cube_acacia_SA`](https://b-cubed-eu.github.io/impIndicator/reference/cube_acacia_SA.md),
[`southAfrica_sf`](https://b-cubed-eu.github.io/impIndicator/reference/southAfrica_sf.md),
[`taxa_Acacia`](https://b-cubed-eu.github.io/impIndicator/reference/taxa_Acacia.md)

## Examples

``` r
head(eicat_acacia, 10)
#> # A tibble: 10 × 3
#>    scientific_name   impact_category impact_mechanism                           
#>    <chr>             <chr>           <chr>                                      
#>  1 Acacia saligna    MC              (1) Competition                            
#>  2 Acacia saligna    MC              (12) Indirect impacts through interaction …
#>  3 Acacia saligna    MC              (1) Competition                            
#>  4 Acacia saligna    MC              (1) Competition; (9) Chemical impact on th…
#>  5 Acacia mearnsii   MC              (6) Poisoning/toxicity                     
#>  6 Acacia longifolia MC              (9) Chemical impact on ecosystems          
#>  7 Acacia dealbata   MC              (9) Chemical impact on ecosystems          
#>  8 Acacia dealbata   MC              (9) Chemical impact on ecosystems          
#>  9 Acacia saligna    MC              (9) Chemical impact on ecosystems          
#> 10 Acacia dealbata   MC              (12) Indirect impacts through interaction …
```
