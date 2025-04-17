#' @title Prepare Data Cubes
#'
#' @description Prepare data cube to calculate species impact .
#' The function `taxa_cube` can take in the scientific name of the
#' taxa of interest as in character or GBIF occurrences data containing
#' necessary columns. The GBIF occurrences is downloaded if scientific
#' names is given.
#'
#' @param taxa Character or dataframe. The character should be the scientific
#' name of the focal taxa while the dataframe is the GBIF occurrences data which
#' must contain columns "decimalLatitude", "decimalLongitude", "species",
#' "speciesKey", "coordinateUncertaintyInMeters", "dateIdentified", and "year".
#' @param region sf or character. The shapefile of the region of study or a
#' character which represent the name of a country
#' @param limit Number of records to return from GBIF download.
#' Default is set to 500
#' @param country Two-letter country code (ISO-3166-1) of the country for which
#' the GBIF occurrences data should be downloaded.
#' @param res The resolution of grid cells to be used. Default is 0.25
#' @param first_year The year from which the occurrence should start from
#' @param last_year The year at which the occurrence should end
#'
#' @return A data cube of `sim_cubes`
#'
#' @family Prepare data
#'
#' @export
#'
#' @examples
#' acacia_cube <- taxa_cube(
#'   taxa = taxa_Acacia,
#'   region = southAfrica_sf,
#'   first_year = 2010
#' )

taxa_cube <- function(
    taxa,
    region,
    limit = 500,
    country = NULL,
    res = 0.25,
    first_year = NULL,
    last_year = NULL) {
  # avoid "no visible binding for global variable" NOTE for the following names
  cellCode <- geometry <- decimalLatitude <- decimalLongitude <- NULL
  species <- speciesKey <- NULL
  coordinateUncertaintyInMeters <- . <- year <- NULL

  # check if res is a number
  if (!assertthat::is.number(res)) {
    cli::cli_abort(c("{.var res} must be a number of length 1"))
  }

  # check if first_year is a number if provided
  if (!is.null(first_year) && !assertthat::is.number(first_year)) {
    cli::cli_abort(
      c("{.var first_year} must be a number of length 1 if provided")
      )
  }

  # check if last_year is a number if provided
  if (!is.null(last_year) && !assertthat::is.number(last_year)) {
    cli::cli_abort(
      c("{.var last_year} must be a number of length 1 if provided")
      )
  }

  if ("sf" %in% class(region)) {
    region <- region %>%
      sf::st_transform(crs = 4326)
  } else if (assertthat::is.string(region)) {

    # download country sf
    region <- rnaturalearth::ne_countries(
        scale = "medium",
        country = region,
        returnclass = "sf"
      ) %>%
      sf::st_as_sf() %>%
      sf::st_transform(crs = 4326)

  } else {
    cli::cli_abort(c("{.var region} must be an {.cls sf} or {.cls character}"))

  }

  grid <- region %>%
    sf::st_transform(crs = 4326) %>%  # transform to EPSG:4326
    sf::st_make_grid(
      cellsize = c(res, res),
      offset = c(
        sf::st_bbox(region)$xmin,
        sf::st_bbox(region)$ymin
      )
    ) %>%
    sf::st_sf() %>%
    dplyr::mutate(cellCode = as.character(dplyr::row_number()))

  # get coordinates of the occurrence sites
  coords <- sf::st_coordinates(sf::st_centroid(grid)) %>%
    as.data.frame() %>%
    tibble::rownames_to_column(var = "cellCode") %>%
    suppressWarnings()

  grid <- grid %>%
    sf::st_intersection(region) %>%
    suppressWarnings() %>%
    dplyr::select(cellCode, geometry)

  #  try to download taxa if the scientific name is given as character
  if (assertthat::is.string(taxa)) {
    taxa.gbif_download <- rgbif::occ_data(
      scientificName = taxa,
      country = country,
      hasCoordinate = TRUE,
      hasGeospatialIssue = FALSE,
      limit = limit
    )
    # extract data from the downloaded file
    taxa.df <- as.data.frame(taxa.gbif_download$data)

    # stop if no download from GBIF
    if (length(taxa.df) == 0) {
      cli::cli_abort(c(
        "No download from GBIF",
        "i" = "Check the {.var taxa} spelling"
      ))
    }

    # check if data fame contains the required columns
  } else if ("data.frame" %in% class(taxa)) {
    if (any(!c(
      "decimalLatitude", "decimalLongitude",
      "species", "speciesKey", "coordinateUncertaintyInMeters",
      "year"
    ) %in% colnames(taxa))) {
      requiredcol <- c(
        "decimalLatitude", "decimalLongitude", "species",
        "speciesKey", "coordinateUncertaintyInMeters",
        "year"
      )
      missingcol <- requiredcol[!c(
        "decimalLatitude", "decimalLongitude", "species",
        "speciesKey", "coordinateUncertaintyInMeters",
        "year"
      ) %in% colnames(taxa)]
      cli::cli_abort(
        c("{.var {missingcol}} {?is/are} not in {.var taxa} column ",
          "x" = "{.var taxa} should be a data of GBIF format ")
        )
    }
    # take taxa data frame if accurate
    taxa.df <- taxa
  } else { # stop and report if taxa is not a scientific name or dataframe
    cli::cli_abort(c("{.var taxa} is not a character or dataframe"))
  }

  taxa.sf <- taxa.df %>%
    dplyr::filter(dplyr::if_all(c(
      "decimalLatitude", "decimalLongitude",
      "species", "speciesKey",
      "coordinateUncertaintyInMeters", "year"
    ), ~ !is.na(.))) %>% # remove rows with missing data
    sf::st_as_sf(
      coords = c("decimalLongitude", "decimalLatitude"),
      crs = 4326
    ) %>%
    sf::st_join(grid) %>%
    as.data.frame() %>%
    dplyr::left_join(coords, by = "cellCode") %>%
    dplyr::select(-geometry) %>%
    dplyr::rename(c(xcoord = "X", ycoord = "Y")) %>%
    dplyr::mutate(occurrences = 1)

  taxa_cube <- b3gbi::process_cube(taxa.sf,
    grid_type = "custom",
    cols_cellCode = "cellCode",
    cols_year = "year",
    cols_occurrences = "occurrences",
    cols_species = "species",
    cols_speciesKey = "speciesKey",
    cols_minCoordinateUncertaintyInMeters =
      "coordinateUncertaintyInMeters",
    first_year = first_year,
    last_year = last_year
  )

  return(taxa_cube)
}
