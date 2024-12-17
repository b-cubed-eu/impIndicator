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
#'   cube = acacia_cube$cube,
#'   impact_data = eicat_data,
#'   col_category = "impact_category",
#'   col_species = "scientific_name",
#'   col_mechanism = "impact_mechanism",
#'   trans = 1,
#'   type = "mean cumulative"
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
  value <- year <- NULL

  if (!inherits(x, "impact_indicator")) {
    cli::cli_abort("'x' is not a class 'impact_indicator'")
  }
  ggplot2::ggplot(data = x) +
    ggplot2::geom_line(ggplot2::aes(y = value, x = year),
      colour = colour,
      stat = "identity",
      linewidth = 2, ...
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
#'#compute species impact
#' speciesImpact <- species_impact(
#'   cube = acacia_cube$cube,
#'   impact_data = eicat_data,
#'   col_category = "impact_category",
#'   col_species = "scientific_name",
#'   col_mechanism = "impact_mechanism",
#'   trans = 1,
#'   type = "mean"
#' )
#'
#' #visualise species impact
#' plot(speciesImpact)
plot.species_impact<-function(x,
                              alien_species="all",
                              linewidth=1.5,
                              title_lab="Species impact",
                              y_lab="impact score",
                              text_size=14,...){
  # avoid R CMD warnings
  impact_score <- year <- `Alien species`<- NULL

  if (!inherits(x, "species_impact")) {
    cli::cli_abort("'x' is not a class 'species_impact'")
  }

  if(alien_species=="all"){
    x %>%
      tibble::rownames_to_column("year") %>%
      dplyr::mutate(year=as.numeric(year)) %>%
      tidyr::gather(-year,key = `Alien species`, value = "impact_score") %>%
      ggplot2::ggplot(ggplot2::aes(x = year, y = impact_score)) +
      ggplot2::geom_line(ggplot2::aes(color = `Alien species`),linewidth=1.5)+
      ggplot2::theme_minimal() +
      ggplot2::labs(
        title = "sum of species impact",
        y = "impact score",...
      )+
      ggplot2::theme(text=ggplot2::element_text(size=14))
  } else {
    x %>%
      dplyr::select(dplyr::all_of(alien_species)) %>%
      tibble::rownames_to_column("year") %>%
      dplyr::mutate(year=as.numeric(year)) %>%
      tidyr::gather(-year,key = `Alien species`, value = "impact_score") %>%
      ggplot2::ggplot(ggplot2::aes(x = year, y = impact_score)) +
      ggplot2::geom_line(ggplot2::aes(color = `Alien species`),linewidth=1.5)+
      ggplot2::theme_minimal() +
      ggplot2::labs(
        title = "sum of species impact",
        y = "impact score",...
      )+
      ggplot2::theme(text=ggplot2::element_text(size=14))
  }
}
