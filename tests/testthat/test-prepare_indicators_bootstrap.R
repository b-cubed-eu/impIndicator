
library(b3gbi) # for processing cube
acacia_cube <- process_cube(
  cube_name = cube_acacia_SA,
  grid_type = "eqdgc",
  first_year = 2010,
  last_year = 2024
)

impact_cube <- create_impact_cube_data(
  cube_data = acacia_cube$data,
  impact_data = eicat_acacia,
)


test_that("prepare_indicators_bootstrap works", {

  expect_no_error(prepare_indicators_bootstrap(
    impact_cube_data = impact_cube,
    indicator = "overall",
    indicator_method = "mean_cum",
    num_bootstrap = 1000,
    grouping_var = "year",
    ci_type = "perc",
    no_bias = TRUE,
    out_var = "taxonKey",
    conf = 0.95
  ))

  expect_no_error(prepare_indicators_bootstrap(
    impact_cube_data = impact_cube,
    indicator = "overall",
    indicator_method = "mean_cum",
    num_bootstrap = 1000,
    grouping_var = "year",
    ci_type = "perc",
    no_bias = TRUE,
    out_var = "taxonKey",
    conf = 0.95,
    seed = 123
  ))
})



test_that("prepare_indicators_bootstrap throw error", {

  expect_error(prepare_indicators_bootstrap(
    impact_cube_data = impact_cube,
    indicator = "site",
    indicator_method = "mean_cum",
    num_bootstrap = 1000,
    grouping_var = "year",
    ci_type = "perc",
    no_bias = TRUE,
    out_var = "taxonKey",
    conf = 0.95
  ),
  "There is no method for indicator site currently")

  expect_error(prepare_indicators_bootstrap(
    impact_cube_data = impact_cube,
    indicator = "species",
    indicator_method = "mean_cum",
    num_bootstrap = 1000,
    grouping_var = "year",
    ci_type = "perc",
    no_bias = TRUE,
    out_var = "taxonKey",
    conf = 0.95
  ),
  "There is no method for indicator species currently")

  expect_error(prepare_indicators_bootstrap(
    impact_cube_data = impact_cube,
    indicator = "a",
    indicator_method = "mean_cum",
    num_bootstrap = 1000,
    grouping_var = "year",
    ci_type = "perc",
    no_bias = TRUE,
    out_var = "taxonKey",
    conf = 0.95
  ))

  expect_error(prepare_indicators_bootstrap(
    impact_cube_data = acacia_cube,
    indicator = "a",
    indicator_method = "mean_cum",
    num_bootstrap = 1000,
    grouping_var = "year",
    ci_type = "perc",
    no_bias = TRUE,
    out_var = "taxonKey",
    conf = 0.95
  ))

})
