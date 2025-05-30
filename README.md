
<!-- README.md is generated from README.Rmd. Please edit that file -->

# impIndicator <img src="man/figures/logo.png" align="right" height="139" alt="" />

<!-- badges: start -->

[![repo
status](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Release](https://img.shields.io/github/release/b-cubed-eu/impIndicator.svg)](https://github.com/b-cubed-eu/impIndicator/releases)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.15052675.svg)](https://doi.org/10.5281/zenodo.15052675)
[![impIndicator status
badge](https://b-cubed-eu.r-universe.dev/impIndicator/badges/version)](https://b-cubed-eu.r-universe.dev/impIndicator)
[![CRAN
status](https://www.r-pkg.org/badges/version/impIndicator)](https://CRAN.R-project.org/package=impIndicator)
[![R-CMD-check](https://github.com/b-cubed-eu/impIndicator/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/b-cubed-eu/impIndicator/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/b-cubed-eu/impIndicator/graph/badge.svg)](https://app.codecov.io/gh/b-cubed-eu/impIndicator)
[![name status
badge](https://b-cubed-eu.r-universe.dev/badges/:name?color=6CDDB4)](https://b-cubed-eu.r-universe.dev/)

<!-- badges: end -->

The goal of **impIndicator** is to allow users to seamlessly calculate
and visualise the impact of alien taxa and individual species in a given
area. It calculates and visualises potential impact per site as a map.
It takes in GBIF occurrence data and EICAT assessment data. It enables
users to choose from various methods of calculating impact indicators
based on different assumptions.  

The impIndicator produces three main products and can be useful as
stated below:  

- **overall impact indicator** \<`compute_impact_indicator()`\>  
  The impact indicator offers a nuanced representation of the trends of
  biological invasions of an area (local, regional, or global scales).
  By tracking the increase and decrease of ecological threats over time,
  this product provides insights into the dynamics of alien species
  impacts, helping assess whether current management practices are
  effective or need adjustment. The temporal analysis of impact
  indicator enables targeted resource allocation, fostering proactive
  interventions to mitigate biodiversity loss and ecosystem
  degradation.  
- **site impact indicator** \<`compute_impact_per_site()`\>  
  The site impact as a map serves as a visual and analytical tool to
  represent the intensity of biological invasions across different parts
  of an area. By enabling spatial comparisons—such as between provinces,
  states, or conservation areas—, it highlights hotspots and areas at
  risk of invasion impact. This spatial data is useful for prioritising
  management actions, coordinating restoration projects, and fostering
  cross-regional collaboration to address alien species impacts
  effectively.  
- **species impact indicator** \<`compute_impact_per_species()`\>  
  The species impact produces the trends of individual alien species,
  enabling a species-specific impact attributed to invasions. This data
  supports comparisons of individual species’ impacts, revealing their
  roles and interactions within invaded area. The species impact is
  invaluable for prioritising species-specific management efforts,
  informing control and eradication strategies, and advancing research
  on alien species’ ecological roles and adaptation patterns.

## Installation

Install **impIndicator** in R:

``` r
install.packages("impIndicator", repos = c("https://b-cubed-eu.r-universe.dev", "https://cloud.r-project.org"))
```

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("b-cubed-eu/impIndicator")
```

## Demonstration

We demonstrate the computation and visualisation of impact indicator of
biological invasions using the **impIndicator** package: the
`compute_impact_indicator()` function to compute impact indicators of
alien taxa, the `compute_impact_per_species()` function to compute
impact indicators per species, and the `compute_impact_per_site()`
function to compute impact indicators per site. The functions require
(1) a species occurrence cube processed by the `b3gbi::process_cube()`
function within `taxa_cube()`, and (2) Environmental Impact
Classification for Alien Taxa (EICAT) impact score of species. Go to
`vignette("Background", package = "impIndicator")` to read more about
these functions.

``` r
# Load packages
library(impIndicator)
#> Warning: package 'impIndicator' was built under R version 4.4.3

library(b3gbi)     # General biodiversity indicators for data cubes
#> Warning: package 'b3gbi' was built under R version 4.4.3
library(ggplot2)   # Visualisation
library(tidyr)     # Data wrangling
```

### Process occurrence cube

The Global Biodiversity Information Facility (GBIF) occurrence data is a
standardised species dataset that documents the presence or absence of
species at particular locations and time points.

``` r
# Process cube from GBIF occurrence data in the R studio environment
acacia_cube <- taxa_cube(
  taxa = taxa_Acacia,
  region = southAfrica_sf,
  first_year = 2010
)

acacia_cube
#> 
#> Simulated data cube for calculating biodiversity indicators
#> 
#> Date Range: 2010 - 2024 
#> Number of cells: 415 
#> Grid reference system: custom 
#> Coordinate range:
#>      xmin      xmax      ymin      ymax 
#>  16.60833  31.60833 -34.69700 -22.94701 
#> 
#> Total number of observations: 6728 
#> Number of species represented: 29 
#> Number of families represented: Data not present 
#> 
#> Kingdoms represented: Data not present 
#> 
#> First 10 rows of data (use n = to show more):
#> 
#> # A tibble: 6,728 × 8
#>    scientificName   taxonKey minCoordinateUncerta…¹  year cellCode xcoord ycoord
#>    <chr>               <dbl>                  <dbl> <dbl> <chr>     <dbl>  <dbl>
#>  1 Acacia mearnsii   2979775                      8  2010 1376       30.4  -29.7
#>  2 Acacia saligna    2978552                      1  2010 206        18.4  -33.9
#>  3 Acacia implexa    2979232                      1  2010 206        18.4  -33.9
#>  4 Acacia pycnantha  2978604                      1  2010 206        18.4  -33.9
#>  5 Acacia cyclops    2980425                    122  2010 668        18.4  -32.2
#>  6 Acacia mearnsii   2979775                   1100  2010 1110       29.9  -30.7
#>  7 Acacia mearnsii   2979775                      1  2010 215        20.6  -33.9
#>  8 Acacia mearnsii   2979775                    110  2010 215        20.6  -33.9
#>  9 Acacia pycnantha  2978604                   1100  2010 143        19.1  -34.2
#> 10 Acacia saligna    2978552                      1  2011 206        18.4  -33.9
#> # ℹ 6,718 more rows
#> # ℹ abbreviated name: ¹​minCoordinateUncertaintyInMeters
#> # ℹ 1 more variable: obs <dbl>
```

### EICAT assessment data

The Environmental Impact Classification for Alien Taxa (EICAT)
assessment data is the reported impact of alien taxa based on EICAT
method which is the International Union for Conservation of Nature
(IUCN) standard. An assessed alien taxa with adequate data is classified
into massive (MV), major (MR), moderate (MO), minor (MN), or minimal
concern (MC) depending on the severity of the impact caused on recipient
ecosystem. Additional information such as the mechanisms and location of
impact are also recorded. An example of an EICAT dataset is:

``` r
# View EICAT data
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

### Compute impact map

The impact risk map shows the impact score for each site, where multiple
species can be present. To compute the impact risk per site, aggregated
scores across species at each site are needed. The `site_impact()` uses
*max*, *sum* and *mean* metrics to aggregate impact scores across
species as proposed by Boulesnane-Guengant et al., (in preparation). The
combinations of within species aggregation metrics for each species and
across species for each site leads to five methods of calculating an
impact indicator, namely, **precautionary** (precaut), **precautionary
cumulative** (precaut_cum), **mean**, **mean cumulative** (mean_cum) and
**cumulative** (cum).  

``` r
siteImpact <- compute_impact_per_site(
  cube = acacia_cube,
  impact_data = eicat_acacia,
  method = "mean_cum"
)

# Impact map
# Visualise last four years for readability
plot(x = siteImpact, region = southAfrica_sf, first_year = 2021)
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

### Compute impact indicators

To compute the impact indicator of alien taxa, we sum all the yearly
impact scores of each site of the study region. To correct for sampling
effort we divide the yearly impact scores by number of sites in the
study region with at least a single occurrence throughout the whole
year.

``` r
# Impact indicator
impactIndicator <- compute_impact_indicator(
  cube = acacia_cube,
  impact_data = eicat_acacia,
  method = "mean_cum"
)

# Visualise impact indicator
plot(impactIndicator)
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />

### Impact indicator per species

We compute the impact indicator per species by summing the impact risk
map per species and correct for sampling effort by dividing by $N$.

``` r
# Impact indicator per species
species_value <- compute_impact_per_species(
  cube = acacia_cube,
  impact_data = eicat_acacia,
  method = "mean"
)

# Visualise species impact
plot(species_value)
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" />
