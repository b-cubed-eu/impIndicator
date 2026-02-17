#' Plot overall impact indicator
#'
#' @description
#' Produces a \code{ggplot2} object showing the temporal trend of the
#' overall impact indicator.
#'
#' @param x An object of class \code{"impact_indicator"} as returned by
#'   \code{compute_impact_indicator()}.
#' @param trend Character string indicating how the central trend should be
#'   displayed. One of:
#'   \describe{
#'     \item{"none"}{No trend line is added.}
#'     \item{"line"}{A straight line connecting yearly values.}
#'     \item{"smooth"}{A loess-smoothed trend.}
#'   }
#'
#' @param point_args A named list of arguments passed to
#'   \code{ggplot2::geom_point()} to customise the appearance of the yearly
#'   impact estimates (e.g. \code{size}, \code{colour}, \code{shape}).
#'
#' @param errorbar_args A named list of arguments passed to
#'   \code{ggplot2::geom_errorbar()} to customise the uncertainty intervals,
#'   if lower (\code{ll}) and upper (\code{ul}) limits are available in
#'   \code{x$impact}.
#'
#' @param trend_args A named list of arguments passed to the trend layer
#'   (\code{ggplot2::geom_line()} or \code{ggplot2::geom_smooth()},
#'   depending on \code{trend}) to customise its appearance (e.g.
#'   \code{colour}, \code{linewidth}, \code{linetype}, \code{alpha}).
#'
#' @param ribbon_args A named list of arguments passed to
#'   \code{ggplot2::geom_ribbon()} to customise the uncertainty ribbon,
#'   if lower (\code{ll}) and upper (\code{ul}) limits are available.
#'
#' @return A \code{ggplot} object representing the overall impact indicator
#'   over time, with years on the x-axis and impact values on the y-axis.
#'
#' @export
#'
#' @family Plot
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
#' impact_value <- compute_impact_indicator(
#'   cube = acacia_cube,
#'   impact_data = eicat_acacia,
#'   method = "mean_cum",
#'   trans = 1
#' )
#'
#' # default plot
#' plot(impact_value)
#'
#' # customised plot
#' plot(
#'   impact_value,
#'   trend = "smooth",
#'   point_args = list(size = 3, colour = "darkred"),
#'   trend_args = list(colour = "black", linewidth = 1),
#'   ribbon_args = list(fill = "grey80", alpha = 0.3)
#' )
plot.impact_indicator <- function(
    x,
    trend = c("none", "line", "smooth"),
    point_args = list(),
    errorbar_args = list(),
    trend_args = list(),
    ribbon_args = list()) {
  # Validation
  trend <- match.arg(trend, c("none", "line", "smooth"))

  if (!inherits(x, "impact_indicator")) {
    cli::cli_abort("'x' is not a class 'impact_indicator'")
  }

  # avoid R CMD warnings
  value <- year <- diversity_val <- ul <- ll <- NULL

  # Visualisation
  p <- ggplot2::ggplot(
    data = x$impact,
    ggplot2::aes(x = year, y = diversity_val)
  )

  # Specify defaults
  default_point <- list(size = 2)
  default_trend <- list(colour = scales::alpha("blue", alpha = 0.5),
                        linewidth = 0.5)
  default_errorbar <- list(width = 0.5, linewidth = 0.8)
  default_ribbon <- list(alpha = 0.4, fill = "lightsteelblue1")

  point_args <- utils::modifyList(default_point, point_args)
  trend_args <- utils::modifyList(default_trend, trend_args)
  errorbar_args <- utils::modifyList(default_errorbar, errorbar_args)
  ribbon_args <- utils::modifyList(default_ribbon, ribbon_args)

  # Plot trends
  if (trend == "line") {
    # plot interval if x contains lower limit and upper limit
    if (all(c("ll", "ul") %in% names(x$impact))) {
      p <- p +
        do.call(
          ggplot2::geom_ribbon,
          utils::modifyList(
            list(mapping = ggplot2::aes(ymin = ll, ymax = ul)),
            ribbon_args
          )
        ) +
        do.call(
          ggplot2::geom_line,
          utils::modifyList(
            list(mapping = ggplot2::aes(y = ul)),
            c(trend_args, linetype = "dashed")
          )
        )  +
        do.call(
          ggplot2::geom_line,
          utils::modifyList(
            list(mapping = ggplot2::aes(y = ll)),
            c(trend_args, linetype = "dashed")
          )
        )
    }

    # Plot trend
    p <- p +
      do.call(
        ggplot2::geom_line,
        trend_args
      )
  } else if (trend == "smooth") {
    # plot interval if x contains lower limit and upper limit
    if (all(c("ll", "ul") %in% names(x$impact))) {
      p <- p +
        do.call(
          ggplot2::geom_ribbon,
          utils::modifyList(
            list(mapping = ggplot2::aes(ymin = predict(loess(ll ~ year)),
                                        ymax = predict(loess(ul ~ year)))),
            ribbon_args
          )
        ) +
        do.call(
          ggplot2::geom_smooth,
          utils::modifyList(
            list(mapping = ggplot2::aes(y = ul)),
            c(trend_args, linetype = "dashed",
              method = "loess", formula = "y ~ x", se = FALSE)
          )
        )  +
        do.call(
          ggplot2::geom_smooth,
          utils::modifyList(
            list(mapping = ggplot2::aes(y = ll)),
            c(trend_args, linetype = "dashed",
              method = "loess", formula = "y ~ x", se = FALSE)
          )
        )
    }

    # Plot trend
    p <- p  +
      do.call(
        ggplot2::geom_smooth,
        c(trend_args, method = "loess", formula = "y ~ x", se = FALSE)
      )
  }

  # Add error bars
  if (all(c("ll", "ul") %in% names(x$impact))) {
    p <- p  +
      do.call(
        ggplot2::geom_errorbar,
        utils::modifyList(
          list(mapping = ggplot2::aes(ymin = ll, ymax = ul)),
          errorbar_args
        )
      )
  }

  # Add estimates
  p <- p  +
    do.call(
      ggplot2::geom_point,
      point_args
    )

  # Styling
  p <- p +
    ggplot2::labs(
      title = "Overall impact indicator",
      y = "Impact value",
      x = "Year"
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      text = ggplot2::element_text(size = 14)
    ) +
    ggplot2::scale_x_continuous(breaks = breaks_pretty_int(n = 10)) +
    ggplot2::scale_y_continuous(breaks = breaks_pretty_int(n = 6))

  return(p)
}

#' Plot species impact
#'
#' @description
#' Produces a ggplot to show the trend of the species impact indicator.
#'
#' @param x A dataframe of impact indicator. Must be a class of "species_impact"
#' @param alien_species The character vector containing names of the alien
#' species to be included in the plot. Default is "all" which plot all species
#' in the data frame
#' @param linewidth The width size of the line. Default is 1.5
#' @param title_lab Title of the plot. Default is "Species impact"
#' @param y_lab Label of the y-axis. Default is "impact score"
#' @param x_lab Label of the x-axis. Default is "Year"
#' @param text_size The size of the text of the plot. Default is "14"
#' @param ... Additional arguments passed to geom_line
#'
#' @return The ggplot object of the species impact, with the y- and x-axes
#' representing the impact score and time respectively.
#'
#' @export
#'
#' @family Plot
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
#' speciesImpact <- compute_impact_per_species(
#'   cube = acacia_cube,
#'   impact_data = eicat_acacia,
#'   method = "mean",
#'   trans = 1
#' )
#'
#' # visualise species impact
#' plot(speciesImpact)

plot.species_impact <- function(
    x,
    alien_species = "all",
    linewidth = 1.5,
    title_lab = "Species impact indicator",
    y_lab = "Impact score",
    x_lab = "Year",
    text_size = 14,
    ...) {
  # avoid R CMD warnings
  impact_score <- year <- `Alien species` <- NULL

  if (!inherits(x, "species_impact")) {
    cli::cli_abort("'x' is not a class 'species_impact'")
  }

  if (length(alien_species) == 1 && alien_species == "all") {
    x$species_impact %>%
      dplyr::mutate(year = as.numeric(year)) %>%
      tidyr::gather(-year, key = `Alien species`, value = "impact_score") %>%
      tidyr::drop_na("impact_score") %>%
      ggplot2::ggplot(ggplot2::aes(x = year, y = impact_score)) +
      ggplot2::geom_line(ggplot2::aes(color = `Alien species`),
                         linewidth = linewidth,
                         ...) +
      ggplot2::theme_minimal() +
      ggplot2::labs(
        title = title_lab,
        y = y_lab,
        x = x_lab
      ) +
      ggplot2::theme(text = ggplot2::element_text(size = text_size)) +
      ggplot2::scale_x_continuous(breaks = breaks_pretty_int(n = 10)) +
      ggplot2::scale_y_continuous(breaks = breaks_pretty_int(n = 6))
  } else if (is.character(alien_species)) {
    x$species_impact %>%
      dplyr::select(dplyr::all_of(c("year", alien_species))) %>%
      dplyr::mutate(year = as.numeric(year)) %>%
      tidyr::gather(-year, key = `Alien species`, value = "impact_score") %>%
      tidyr::drop_na("impact_score") %>%
      ggplot2::ggplot(ggplot2::aes(x = year, y = impact_score)) +
      ggplot2::geom_line(ggplot2::aes(color = `Alien species`),
                         linewidth = linewidth,
                         ...) +
      ggplot2::theme_minimal() +
      ggplot2::labs(
        title = title_lab,
        y = y_lab,
        x = x_lab
      ) +
      ggplot2::theme(text = ggplot2::element_text(size = text_size)) +
      ggplot2::scale_x_continuous(breaks = breaks_pretty_int(n = 10)) +
      ggplot2::scale_y_continuous(breaks = breaks_pretty_int(n = 6))
  } else {
    cli::cli_abort(c(
      paste("Invalid input for {.var alien_species}.",
            "Must be 'all' or a {.cls character} vector"),
      "x" = "You've supplied a {.cls {class (alien_species)}}"))
  }
}

#' Plot site impact
#'
#' @description
#' Produces the ggplot of site impact indicator
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
#'
#' @export
#'
#' @family Plot
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
#' siteImpact <- compute_impact_per_site(
#'   cube = acacia_cube,
#'   impact_data = eicat_acacia,
#'   method = "mean_cum",
#'   trans = 1
#'
#' )
#'
#' # visualise site impact
#' plot(x = siteImpact, region = southAfrica_sf, first_year = 2021)

plot.site_impact <- function(
    x,
    region = NULL,
    first_year = NULL,
    last_year = NULL,
    title_lab = "Site Impact map",
    text_size = 14,
    ...) {
  # avoid R CMD warnings (global variable not found)
  year <- xcoord <- ycoord <- impact <- cellCode <- NULL


  if (!inherits(x, "site_impact")) {
    cli::cli_abort("'x' is not a class 'site_impact'")
  }

  x <- x$site_impact %>%
    tidyr::gather(-c(cellCode, xcoord, ycoord),
                  key = "year", value = "impact") %>%
    stats::na.omit()

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

  } else if ("sf" %in% class(region)) {
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
  } else if (assertthat::is.string(region)) {
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
