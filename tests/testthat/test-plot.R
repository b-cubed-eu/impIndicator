acacia_cube <- taxa_cube(
  taxa = taxa_Acacia,
  region = southAfrica_sf,
  res = 0.25,
  first_year = 2010
)

# compute impact indicator
impact_value <- impact_indicator(
  cube = acacia_cube,
  impact_data = eicat_acacia,
  col_category = "impact_category",
  col_species = "scientific_name",
  col_mechanism = "impact_mechanism",
  trans = 1,
  type = "mean cumulative"
)

test_that("plot.impact_indicator works",{

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
                       y_lab = "impact score",
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
                       linejoin="round"

  ))
})

test_that("plot.impact indicator throws error",{

  # wrong class of impact indicator
  wrong_class_impact_indicator <- as.data.frame(impact_value)
  expect_error(plot.impact_indicator(wrong_class_impact_indicator,
                       linewidth = 2,
                       colour = "red",
                       title_lab = "Impact indicator",
                       y_lab = "impact score",
                       text_size = 14

  ),
  "'x' is not a class 'impact_indicator'")
#
#   expect_error(plot(impact_value,
#                     linewidth = "a",
#                     colour = "red",
#                     title_lab = "Impact indicator",
#                     y_lab = "impact score",
#                     text_size = 14
#
#   ))
#
#   expect_error(plot(impact_value,
#                        linewidth = 2,
#                        colour = "invalid_colour",
#                        title_lab = "Impact indicator",
#                        y_lab = "impact score",
#                        text_size = 15
#
#   ))
#
#   expect_error(plot(impact_value,
#                     linewidth = 2,
#                     colour = "red",
#                     title_lab = 3,
#                     y_lab = "impact score",
#                     text_size = 15
#
#   ))
#
#   expect_error(plot(impact_value,
#                     linewidth = 2,
#                     colour = "red",
#                     title_lab = "Impact indicator",
#                     y_lab =4,
#                     text_size = 15
#
#   ))
#
#   expect_error(plot(impact_value,
#                     linewidth = 2,
#                     colour = "red",
#                     title_lab = "Impact indicator",
#                     y_lab = "impact score",
#                     text_size = "a"
#
#   ))
})


##### Plot method for specie impact ####

# compute species impact
speciesImpact <- species_impact(
  cube = acacia_cube,
  impact_data = eicat_acacia,
  col_category = "impact_category",
  col_species = "scientific_name",
  col_mechanism = "impact_mechanism",
  trans = 1,
  type = "mean"
)


test_that("plot.species_impact works", {
  expect_no_error(plot(speciesImpact))

  expect_no_error(plot(speciesImpact,
                           alien_species = "all",
                           linewidth = 1.5,
                           title_lab = "Species impact",
                           y_lab = "impact score",
                           text_size = 14))

  some_alien <- names(speciesImpact)[2:5]

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

test_that("plot.species_impact throws error",{


  # class is not species_impact
  wrong_class <- as.data.frame(speciesImpact)
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
siteImpact <- site_impact(
  cube = acacia_cube,
  impact_data = eicat_acacia,
  col_category = "impact_category",
  col_species = "scientific_name",
  col_mechanism = "impact_mechanism",
  trans = 1,
  type = "precautionary cumulative"
)


test_that("Plot.site_impact works",{
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

test_that("Plot.site_impact throws error",{

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
  wrong_class_site_impact <-as.matrix(siteImpact)
  expect_error(plot.site_impact(wrong_class_site_impact,
                       region = NULL,
                       first_year = NULL,
                       last_year = NULL,
                       title_lab = "Impact map",
                       text_size = 14))
})
