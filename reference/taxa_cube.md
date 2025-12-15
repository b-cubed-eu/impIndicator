# Build occurrences cube

Prepare data cube to calculate species impact . The function `taxa_cube`
can take in the scientific name of the taxa of interest as in character
or GBIF occurrences data containing necessary columns. The GBIF
occurrences is downloaded if scientific names is given.

## Usage

``` r
taxa_cube(
  taxa,
  region,
  limit = 500,
  country = NULL,
  res = 0.25,
  first_year = NULL,
  last_year = NULL
)
```

## Arguments

- taxa:

  Character or dataframe. The character should be the scientific name of
  the focal taxa while the dataframe is the GBIF occurrences data which
  must contain columns "decimalLatitude", "decimalLongitude", "species",
  "speciesKey", "coordinateUncertaintyInMeters", "dateIdentified", and
  "year".

- region:

  sf or character. The shapefile of the region of study or a character
  which represent the name of a country

- limit:

  Number of records to return from GBIF download. Default is set to 500

- country:

  Two-letter country code (ISO-3166-1) of the country for which the GBIF
  occurrences data should be downloaded.

- res:

  The resolution of grid cells to be used. Default is 0.25

- first_year:

  The year from which the occurrence should start from

- last_year:

  The year at which the occurrence should end

## Value

A data cube of `sim_cubes`

## See also

Other Prepare data:
[`impact_cat()`](https://b-cubed-eu.github.io/impIndicator/reference/impact_cat.md)

## Examples

``` r
acacia_cube <- taxa_cube(
  taxa = taxa_Acacia,
  region = southAfrica_sf,
  first_year = 2010
)
```
