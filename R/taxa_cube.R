#' @title Prepare Data Cubes
#'
#' @description Prepare data cube to calculate species impact .
#' The function `taxa_cube` can take in the scientific name of the
#' taxa of interest as in character or GBIF occurrences data containing
#' necessary columns. The GBIF occurrences is downloaded if scientific
#' names is given.
#'
#' @param taxa Character or dataframe. The character should be the scientific
#' name of the focal taxa while the dataframe is the GBIF occurrences data which must
#' contain "decimalLatitude","decimalLongitude","species","speciesKey",
#' "coordinateUncertaintyInMeters","dateIdentified", and "year".
#' @param region The shapefile of the region of study
#' @param limit Number of records to return from GBIF download.
#' Default is set to 500
#'
#' @param country Two-letter country code (ISO-3166-1) of Country for which
#' the GBIP occurrences data should be downloaded.
#' @param res The resolution of grid cells to be used. Default is 0.25
#' @param first_year The year from which the occurrence should start from
#'
#' @return A list containing the `sim_cubes` of taxa and the dataframe of
#' coordinates of sites
#'
#' @export
#'
#' @examples
#'
#' acacia_cube<-taxa_cube(taxa=taxa_Acacia,
#'                        region=southAfrica_sf,
#'                        res=0.25,
#'                        first_year=2010)
#'

taxa_cube <- function(taxa,
                      region,
                      limit=500,
                      country=NULL,
                      res=0.25,
                      first_year=NULL){


  #check if first_year is a number
  if(!is.null(first_year)){
    assertthat::assert_that(assertthat::is.number(first_year),
                            msg ="`first_year` must be a number if provided" )
  }


  grid <- region %>%
    sf::st_make_grid(cellsize = c(res,res),
                     offset = c(sf::st_bbox(region)$xmin,
                                sf::st_bbox(region)$ymin)) %>%
    sf::st_sf() %>%
    dplyr::mutate(cellid = dplyr::row_number())

  grid_filtered <- grid %>%
    suppressWarnings(sf::st_intersection(region)) %>%
    dplyr::select(cellid,geometry)


  # get coordinates of the occurrence sites
  coords <- sf::st_coordinates(sf::st_centroid(grid)) %>%
    as.data.frame() %>%
    tibble::rownames_to_column(var = "siteID") %>%
    suppressWarnings()

  #  try to download taxa if the scientific name is given as character
  if("character" %in% class(taxa)){
    taxa.gbif_download = rgbif::occ_data(scientificName=taxa,
                                         country=country,
                                         hasCoordinate=TRUE,
                                         hasGeospatialIssue=FALSE,
                                         limit = limit)
    #extract data from the downloaded file
    taxa.df = as.data.frame(taxa.gbif_download$data)
    #check if data fame contains the required columns
  } else if("data.frame" %in% class(taxa)){
    if(any(!c("decimalLatitude","decimalLongitude",
              "species","speciesKey","coordinateUncertaintyInMeters",
              "year") %in% colnames(taxa))){
      requiredcol<-c("decimalLatitude","decimalLongitude","species",
                     "speciesKey","coordinateUncertaintyInMeters",
                     "year")
      missingcol<-requiredcol[!c("decimalLatitude","decimalLongitude","species",
                                 "speciesKey","coordinateUncertaintyInMeters",
                                 "year") %in% colnames(taxa)]
      cli::cli_abort(c("{missingcol} is/are not in the {.var taxa} column ",
                       "x" = "{.var taxa} should be a data of GBIF format "))
    }
    # take taxa data frame if accurate
    taxa.df<-taxa
  } else { # stop and report if taxa is not a scientific name or dataframe
    cli::cli_abort(c("{.var taxa} is not a character or dataframe"))
  }


  taxa.sf = taxa.df %>%
    dplyr::select(decimalLatitude,decimalLongitude,
                  species,speciesKey,
                  coordinateUncertaintyInMeters,year) %>% #select occurrence data
    dplyr::filter_all(dplyr::all_vars(!is.na(.))) %>% # remove rows with missing data
    dplyr::filter(coordinateUncertaintyInMeters<=res*1000) %>%
    sf::st_as_sf(coords = c("decimalLongitude", "decimalLatitude"),
                 crs = 4326) %>%
    sf::st_join(grid_filtered) %>%
    as.data.frame() %>%
    dplyr::select(-geometry) %>%
    dplyr::mutate(occurrences=1)


  taxa_cube<-b3gbi::process_cube(taxa.sf,grid_type = "custom",
                                 cols_cellCode = "cellid",
                                 cols_year = "year",
                                 cols_occurrences = "occurrences",
                                 cols_species = "species",
                                 cols_speciesKey = "speciesKey",
                                 cols_minCoordinateUncertaintyInMeters = "coordinateUncertaintyInMeters",
                                 first_year = first_year)

  return(list("cube"=taxa_cube,"coords"=coords))
}

