acacia_cube <- taxa_cube(
  taxa = taxa_Acacia,
  region = southAfrica_sf,
  res = 0.25,
  first_year = 2010
)
impact_value <- impact_indicator(
  cube = acacia_cube,
  impact_data = eicat_data,
  col_category = "impact_category",
  col_species = "scientific_name",
  col_mechanism = "impact_mechanism",
  trans = 1,
  type = "mean cumulative"
)


# compute species impact
speciesImpact <- species_impact(
  cube = acacia_cube,
  impact_data = eicat_data,
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
#
#   some_alien <- names(speciesImpact)[1:4]
#
#   expect_no_error(plot(speciesImpact,
#                        alien_species = some_alien,
#                        linewidth = 1.5,
#                        title_lab = "Species impact",
#                        y_lab = "impact score",
#                        text_size = 14))

})
