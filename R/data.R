#' GBIF occurrences data of acacia in South Africa
#' An example of occurrence data from GBIF containing required column for impact indicator.
#'
#' @format A dataframe object containing 19,100 rows and 6 variables
#' \describe{
#'   \item{decimalLatitude}{geographic latitude in decimal}
#'   \item{decimalLongitude}{geographic longitude in decimal}
#'   \item{species}{scientific name of species}
#'   \item{speciesKey}{GBIF species identification number}
#'   \item{coordinateUncertaintyInMeters}{radius of the uncertainty circle around geographic point}
#'   \item{year}{year occurrence was recorded}
#' }
#' @family Data
#' @examples
#'   head(taxa_Acacia,10)
#'
#' @source \url{https://doi.org/10.15468/dl.b6gda5}
"taxa_Acacia"



#' South African sf
#' An example of region sf for impact indicator.
#'
#' @format A 'sf' object of South African map
#' \describe{
#'   \item{geometry}{geometry of polygon}

#' }
#' @family Data
#' @examples
#'   sf::plot_sf(southAfrica_sf)
#'
"southAfrica_sf"



#' EICAT data of acacia taxa
#' An example of EICAT data containing species name, impact category and mechanism.
#'
#' @format A dataframe object containing 138 observations and 3 variables
#' \describe{
#'   \item{scientific_name}{species scientific name}
#'   \item{impact_category}{EICAT impact category}
#'   \item{impact_mechanism}{mecahnism of impact}
#' }
#' @family Data
#' @examples
#'   head(eicat_acacia,10)
#'
#' @source Jansen, C., Kumschick, S. A global impact assessment of Acacia species
#' introduced to South Africa. Biol Invasions 24, 175–187 (2022).
#' \url{https://doi.org/10.1007/s10530-021-02642-0}
"eicat_acacia"
