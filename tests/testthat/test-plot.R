library(b3gbi) # for processing cube
acacia_cube <- process_cube(cube_name = cube_acacia_SA,
                            grid_type = "eqdgc",
                            first_year = 2010,
                            last_year = 2024)

# compute impact indicator
impact_value <- compute_impact_indicator(
  cube = acacia_cube,
  impact_data = eicat_acacia,
  method = "mean_cum"
)

# impact indicator with confidence interval
impact_value_ci <- compute_impact_indicator(
  cube = acacia_cube,
  impact_data = eicat_acacia,
  method = "mean_cum",
  ci = TRUE,
  num_bootstrap = 100
)


test_that("plot.impact_indicator works", {

  expect_no_error(plot(impact_value,
                                linewidth = 2,
                                colour = "red",
                                title_lab = "Impact indicator",
                                y_lab = "impact score",
                                text_size = 14

  ))

  expect_no_error(plot(impact_value,
                       linewidth = 1,
                       colour = "red",
                       title_lab = "Impact indicator",
                       y_lab = "impact score",
                       text_size = 14

  ))

  expect_no_error(plot(impact_value,
                       linewidth = 2,
                       colour = "blue",
                       title_lab = "Impact indicator",
                       y_lab = "Impact score",
                       text_size = 14

  ))

  expect_no_error(plot(impact_value,
                       linewidth = 2,
                       colour = "red",
                       title_lab = "Title name",
                       y_lab = "impact score",
                       text_size = 14

  ))

  expect_no_error(plot(impact_value,
                       linewidth = 2,
                       colour = "red",
                       title_lab = "Impact indicator",
                       y_lab = "y axis",
                       text_size = 14

  ))

  expect_no_error(plot(impact_value,
                       linewidth = 2,
                       colour = "red",
                       title_lab = "Impact indicator",
                       y_lab = "impact score",
                       text_size = 15

  ))

  # additional argument to geom_line
  expect_no_error(plot(impact_value,
                       linewidth = 2,
                       colour = "red",
                       title_lab = "Impact indicator",
                       y_lab = "impact score",
                       text_size = 14,
                       linejoin = "round"

  ))

  expect_no_error(plot(impact_value_ci,
                       linewidth = 2,
                       colour = "red",
                       title_lab = "Impact indicator",
                       y_lab = "impact score",
                       text_size = 14

  ))

  expect_no_error(plot(impact_value_ci,
                       linewidth = 2,
                       colour = "red",
                       title_lab = "Impact indicator",
                       y_lab = "impact score",
                       text_size = 14,
                       ribbon_colour = "black"

  ))
})

test_that("plot.impact indicator throws error", {

  # wrong class of impact indicator
  wrong_class_impact_indicator <- structure(impact_value, class="wrong_class")
  expect_error(plot.impact_indicator(wrong_class_impact_indicator,
                       linewidth = 2,
                       colour = "red",
                       title_lab = "Impact indicator",
                       y_lab = "impact score",
                       text_size = 14

  ),
  "'x' is not a class 'impact_indicator'")
})


##### Plot method for specie impact ####

# compute species impact
speciesImpact <- compute_impact_per_species(
  cube = acacia_cube,
  impact_data = eicat_acacia,
  col_category = "impact_category",
  col_species = "scientific_name",
  col_mechanism = "impact_mechanism",
  trans = 1,
  method = "mean"
)


test_that("plot.species_impact works", {
  expect_no_error(plot(speciesImpact))

  expect_no_error(plot(speciesImpact,
                           alien_species = "all",
                           linewidth = 1.5,
                           title_lab = "Species impact",
                           y_lab = "impact score",
                           text_size = 14))

  some_alien <- names(speciesImpact$species_impact)[2:5]

  expect_no_error(plot(speciesImpact,
                       alien_species = some_alien,
                       linewidth = 1.5,
                       title_lab = "Species impact",
                       y_lab = "impact score",
                       text_size = 14))


  expect_no_error(plot(speciesImpact,
                       alien_species = some_alien,
                       linewidth = 2.0,
                       title_lab = "Species impact",
                       y_lab = "impact score",
                       text_size = 14))

  expect_no_error(plot(speciesImpact,
                       alien_species = some_alien,
                       linewidth = 2.0,
                       title_lab = "Species impact",
                       y_lab = "impact score",
                       text_size = 15))

  expect_no_error(plot(speciesImpact,
                       alien_species = some_alien,
                       linewidth = 2.0,
                       title_lab = "Title name",
                       y_lab = "impact score",
                       text_size = 14))

  expect_no_error(plot(speciesImpact,
                       alien_species = some_alien,
                       linewidth = 2.0,
                       title_lab = "Species impact",
                       y_lab = "Y axis",
                       text_size = 14))
})

test_that("plot.species_impact throws error", {


  # class is not species_impact
  wrong_class <- structure(speciesImpact, class = "wrong_class")
  expect_error(plot.species_impact(wrong_class,
                       alien_species = some_alien,
                       linewidth = 2.0,
                       title_lab = "Species impact",
                       y_lab = "impact score",
                       text_size = 14),
               "'x' is not a class 'species_impact'")

  expect_error(plot(speciesImpact,
                    alien_species = 1000,
                    linewidth = 1.5,
                    title_lab = "Species impact",
                    y_lab = "impact score",
                    text_size = 14))
})


#### Plot method for site impact ####

# compute site impact
siteImpact <- compute_impact_per_site(
  cube = acacia_cube,
  impact_data = eicat_acacia,
  col_category = "impact_category",
  col_species = "scientific_name",
  col_mechanism = "impact_mechanism",
  trans = 1,
  method = "precaut_cum"
)


test_that("Plot.site_impact works", {
  expect_no_error(plot(siteImpact,
                       region = NULL,
                       first_year = NULL,
                       last_year = NULL,
                       title_lab = "Impact map",
                       text_size = 14))

  expect_no_error(plot(siteImpact,
                       region = southAfrica_sf,
                       first_year = NULL,
                       last_year = NULL,
                       title_lab = "Impact map",
                       text_size = 14))

  expect_no_error(plot(siteImpact,
                       region = "South Africa",
                       first_year = NULL,
                       last_year = NULL,
                       title_lab = "Impact map",
                       text_size = 14))


  expect_no_error(plot(siteImpact,
                       region = NULL,
                       first_year = 2021,
                       last_year = NULL,
                       title_lab = "Impact map",
                       text_size = 14))

  expect_no_error(plot(siteImpact,
                       region = NULL,
                       first_year = NULL,
                       last_year = 2024,
                       title_lab = "Impact map",
                       text_size = 14))

  expect_no_error(plot(siteImpact,
                       region = NULL,
                       first_year = NULL,
                       last_year = NULL,
                       title_lab = "Title",
                       text_size = 14))

  expect_no_error(plot(siteImpact,
                       region = NULL,
                       first_year = NULL,
                       last_year = NULL,
                       title_lab = "Impact map",
                       text_size = 16))

})

test_that("Plot.site_impact throws error", {

  expect_error(plot(siteImpact,
                       region = "a",
                       first_year = NULL,
                       last_year = NULL,
                       title_lab = "Impact map",
                       text_size = 14))

  expect_error(plot(siteImpact,
                       region = NULL,
                       first_year = "a",
                       last_year = NULL,
                       title_lab = "Impact map",
                       text_size = 14))

  expect_error(plot(siteImpact,
                       region = NULL,
                       first_year = NULL,
                       last_year = "a",
                       title_lab = "Impact map",
                       text_size = 14))

  expect_error(plot(siteImpact,
                       region = NULL,
                       first_year = NULL,
                       last_year = NULL,
                       title_lab = "Impact map",
                       text_size = "a"))

  # siteImpact is not of correct class
  wrong_class_site_impact <- as.matrix(siteImpact)
  expect_error(plot.site_impact(wrong_class_site_impact,
                       region = NULL,
                       first_year = NULL,
                       last_year = NULL,
                       title_lab = "Impact map",
                       text_size = 14))
})
