#' GBIF occurrences data of acacia in South Africa
#' An example of occurrence data from GBIF containing required column for impact indicator.
#'
#' @format A dataframe object containing 17,279 rows and 6variables
#' \describe{
#'   \item{decimalLatitude}{geographic latitude in decimal}
#'   \item{decimalLongitude}{geographic longitude in decimal}
#'   \item{species}{scientific name of species}
#'   \item{speciesKey}{GBIF species identification number}
#'   \item{coordinateUncertaintyInMeters}{radius of the uncertainty circle around geographic point}
#'   \item{year}{year occurrence was recorded}
#' }
#' @examples
#'   head(taxa_Acacia,10)
#'
#' @source \url{https://www.gbif.org/occurrence/search?country=ZA&taxon_key=2978223&occurrence_status=present}
"taxa_Acacia"



#' South African sf
#' An example of region sf for impact indicator.
#'
#' @format A 'sf' object of South African map
#' \describe{
#'   \item{geometry}{geometry of polygon}

#' }
#' @examples
#'   plot(southAfrica_sf)
#'

"southAfrica_sf"
