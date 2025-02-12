#' Plot impact indicator
#'
#' @description
#' Produces a ggplot object to show the trend of the impact.
#'
#'
#' @param x A dataframe of impact indicator. Must be a class of "impact_indicator"
#' @param linewidth The width size of the line. Default is 2
#' @param colour The colour of the line Default is "red"
#' @param title_lab Title of the plot. Default is "Impact indicator"
#' @param y_lab Label of the y-axis. Default is "impact score"
#' @param text_size The size of the text of the plot. Default is "14"
#' @param ... Additional arguments passed to geom_line
#'
#' @return The ggplot object of the impact indicator, with the y- and x-axes
#' representing the impact score and time respectively.
#' @export
#'
#' @examples
#' # create data_cube
#' acacia_cube <- taxa_cube(
#'   taxa = taxa_Acacia,
#'   region = southAfrica_sf,
#'   res = 0.25,
#'   first_year = 2010
#' )
#'
#' # compute impact indicator
#' impact_value <- impact_indicator(
#'   cube = acacia_cube,
#'   impact_data = eicat_acacia,
#'   method = "mean cumulative",
#'   trans = 1
#' )
#' # plot impact indicator
#' plot(impact_value)
#'
plot.impact_indicator <- function(x,
                                  linewidth = 2,
                                  colour = "red",
                                  title_lab = "Impact indicator",
                                  y_lab = "impact score",
                                  text_size = 14, ...) {
  # avoid R CMD warnings
  value <- year <- diversity_val <- NULL

  if (!inherits(x, "impact_indicator")) {
    cli::cli_abort("'x' is not a class 'impact_indicator'")
  }
  ggplot2::ggplot(data = x) +
    ggplot2::geom_line(ggplot2::aes(y = diversity_val, x = year),
      colour = colour,
      stat = "identity",
      linewidth = linewidth, ...
    ) +
    ggplot2::labs(
      title = title_lab,
      y = y_lab
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(text = ggplot2::element_text(size = text_size))
}


#' Plot species impact
#'
#' @description
#' Produces a ggplot to show the trend of the species impact.
#'
#' @param x A dataframe of impact indicator. Must be a class of "species_impact"
#' @param alien_species The character vector containing names of the alien
#' species to be included in the plot. Default is "all" which plot all species
#' in the data frame
#' @param linewidth The width size of the line. Default is 1.5
#' @param title_lab Title of the plot. Default is "Species impact"
#' @param y_lab Label of the y-axis. Default is "impact score"
#' @param text_size The size of the text of the plot. Default is "14"
#' @param ... Additional arguments passed to geom_line
#'
#' @return The ggplot object of the species impact, with the y- and x-axes
#' representing the impact score and time respectively.
#' @export
#'
#' @examples
#' # create data cube
#' acacia_cube <- taxa_cube(
#'   taxa = taxa_Acacia,
#'   region = southAfrica_sf,
#'   res = 0.25,
#'   first_year = 2010
#' )
#'
#' # compute species impact
#' speciesImpact <- species_impact(
#'   cube = acacia_cube,
#'   impact_data = eicat_acacia,
#'   method = "mean",
#'   trans = 1
#' )
#'
#' # visualise species impact
#' plot(speciesImpact)
plot.species_impact <- function(x,
                                alien_species = "all",
                                linewidth = 1.5,
                                title_lab = "Species impact",
                                y_lab = "impact score",
                                text_size = 14, ...) {
  # avoid R CMD warnings
  impact_score <- year <- `Alien species` <- NULL

  if (!inherits(x, "species_impact")) {
    cli::cli_abort("'x' is not a class 'species_impact'")
  }

  if (length(alien_species) == 1 && alien_species == "all") {
    x %>%
      dplyr::mutate(year = as.numeric(year)) %>%
      tidyr::gather(-year, key = `Alien species`, value = "impact_score") %>%
      ggplot2::ggplot(ggplot2::aes(x = year, y = impact_score)) +
      ggplot2::geom_line(ggplot2::aes(color = `Alien species`), linewidth = linewidth) +
      ggplot2::theme_minimal() +
      ggplot2::labs(
        title = title_lab,
        y = y_lab, ...
      ) +
      ggplot2::theme(text = ggplot2::element_text(size = text_size))
  } else if (is.character(alien_species)){
    x %>%
      dplyr::select(dplyr::all_of(c("year",alien_species))) %>%
      dplyr::mutate(year = as.numeric(year)) %>%
      tidyr::gather(-year, key = `Alien species`, value = "impact_score") %>%
      ggplot2::ggplot(ggplot2::aes(x = year, y = impact_score)) +
      ggplot2::geom_line(ggplot2::aes(color = `Alien species`), linewidth = linewidth) +
      ggplot2::theme_minimal() +
      ggplot2::labs(
        title = title_lab,
        y = y_lab, ...
      ) +
      ggplot2::theme(text = ggplot2::element_text(size = text_size))
  }
  else {
    cli::cli_abort(c(
      "Invalid input for {.var alien_species}. Must be 'all' or a {.cls character} vector",
      "x"="You've supplied a {.cls {class (alien_species)}}"))
  }
}


#' Plot site impact
#'
#' @description
#' Produces the yearly impact map of a region
#'
#' @param x A dataframe of impact indicator. Must be a class of "site_impact"
#' @param region sf or character. The shapefile of the region of study or a
#' character which represent the name of a country. It is not compulsory
#' but makes the plot more comprehensible.
#' @param first_year The first year the impact map should include.
#' Default starts from the first year included in `x`.
#' @param last_year The last year the impact map should include.
#' Default ends in the last year included in `x`.
#' @param title_lab Title of the plot. Default is "Impact map"
#' @param text_size The size of the text of the plot. Default is "14"
#' @param ... Additional arguments passed to geom_tile
#'
#' @return The ggplot of species yearly impact on the region.
#' @export
#'
#' @examples
#' # define cube for taxa
#' acacia_cube <- taxa_cube(
#'   taxa = taxa_Acacia,
#'   region = southAfrica_sf,
#'   res = 0.25,
#'   first_year = 2010
#' )
#'
#' # compute site impact
#' siteImpact <- site_impact(
#'   cube = acacia_cube,
#'   impact_data = eicat_acacia,
#'   method = "precautionary cumulative",
#'   trans = 1
#'
#' )
#'
#' # visualise site impact
#' plot(x=siteImpact,
#' region= southAfrica_sf,
#' first_year = 2021)
plot.site_impact <- function(x,
                             region = NULL,
                             first_year = NULL,
                             last_year = NULL,
                             title_lab = "Impact map",
                             text_size = 14, ...) {
  # avoid R CMD warnings (global varaible not found)
  year <- xcoord <- ycoord <- impact <- cellCode <- NULL


  if (!inherits(x, "site_impact")) {
    cli::cli_abort("'x' is not a class 'site_impact'")
  }

  x <- x %>%
    tidyr::gather(-c(cellCode, xcoord, ycoord), key = "year", value = "impact") %>%
    stats::na.omit()

  # check if first_year is a number if provided
  if (!is.null(first_year) & !assertthat::is.number(first_year)) {
    cli::cli_abort(c("{.var first_year} must be a number of length 1 if provided"))
  }

  # check if last_year is a number if provided
  if (!is.null(last_year) & !assertthat::is.number(last_year)) {
    cli::cli_abort(c("{.var last_year} must be a number of length 1 if provided"))
  }

  # check if text_size is a number
  if (!assertthat::is.number(text_size)) {
    cli::cli_abort(c("{.var text_size} must be a number of length 1"))
  }

  if (!is.null(first_year)) {
    x <- x %>%
      dplyr::filter(year >= first_year)
  }

  if (!is.null(last_year)) {
    x <- x %>%
      dplyr::filter(year <= last_year)
  }


  if (is.null(region)) {
    x %>%
      ggplot2::ggplot() +
      ggplot2::geom_tile(
        ggplot2::aes(x = xcoord, y = ycoord, fill = impact),
        color = "black", ...
      ) +
      ggplot2::scale_fill_gradient(
        low = "yellow",
        high = "red"
      ) +
      ggplot2::theme_minimal() +
      ggplot2::labs(
        title = title_lab,
        y = "Latitude", x = "Longitude"
      ) +
      ggplot2::theme(text = ggplot2::element_text(size = text_size)) +
      ggplot2::facet_wrap(~year)

  } else if ("sf" %in% class(region)){
    x %>%
      ggplot2::ggplot() +
      ggplot2::geom_tile(
        ggplot2::aes(x = xcoord, y = ycoord, fill = impact),
        color = "black", ...
      ) +
      ggplot2::geom_sf(data = region, fill = NA, color = "black", alpha = 0.5) +
      ggplot2::scale_fill_gradient(
        low = "yellow",
        high = "red"
      ) +
      ggplot2::theme_minimal() +
      ggplot2::labs(
        title = title_lab,
        y = "Latitude", x = "Longitude"
      ) +
      ggplot2::theme(text = ggplot2::element_text(size = text_size)) +
      ggplot2::facet_wrap(~year)
  } else if(assertthat::is.string(region)){

    # download country sf
    region <- rnaturalearth::ne_countries(scale = "medium",
                                          country = region,
                                          returnclass = "sf") %>%
      sf::st_as_sf() %>%
      sf::st_transform(crs = 4326)

    x %>%
      ggplot2::ggplot() +
      ggplot2::geom_tile(
        ggplot2::aes(x = xcoord, y = ycoord, fill = impact),
        color = "black", ...
      ) +
      ggplot2::geom_sf(data = region, fill = NA, color = "black", alpha = 0.5) +
      ggplot2::scale_fill_gradient(
        low = "yellow",
        high = "red"
      ) +
      ggplot2::theme_minimal() +
      ggplot2::labs(
        title = title_lab,
        y = "Latitude", x = "Longitude"
      ) +
      ggplot2::theme(text = ggplot2::element_text(size = text_size)) +
      ggplot2::facet_wrap(~year)

  } else {
    cli::cli_abort(c("{.var region} must be an {.cls sf} or {.cls character}"))
  }
}
