# Define cube
library(b3gbi) # for processing cube
acacia_cube <- process_cube(cube_name = cube_acacia_SA,
                            grid_type = "eqdgc",
                            first_year = 2010,
                            last_year = 2024)

test_that("impact indicator function return correct result", {
  result <- compute_impact_indicator(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    method = "mean_cum",
    ci_type = "perc",
    num_bootstrap = 100
  )

  expect_equal(class(result),
               "impact_indicator")

  expect_equal(unique(acacia_cube$data$year), result$impact[[1]])

  expect_no_error(result)

  expect_no_error(compute_impact_indicator(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    method = "mean_cum"
  ))

  expect_no_error(compute_impact_indicator(
    cube = acacia_cube$data,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    method = "mean_cum"
  ))
  expect_no_error(compute_impact_indicator(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    method = "mean"
  ))

  expect_no_error(compute_impact_indicator(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    method = "cum"
  ))


  expect_no_error(compute_impact_indicator(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    method = "precaut_cum"
  ))

  expect_no_error(compute_impact_indicator(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    method = "precaut"
  ))

  expect_no_error(compute_impact_indicator(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    method = "precaut",
    region = southAfrica_sf,
    ci_type = "none"
  ))

  impact_cube<-create_impact_cube_data(
    cube_data = acacia_cube,
    impact_data = eicat_acacia
  )

  expect_no_error(compute_impact_indicator(
    cube = impact_cube,
    method = "precaut"
  ))

})

test_that("impact indicator function returns errors", {
  expect_error(compute_impact_indicator(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    method = "a"
  ))

  expect_error(
    compute_impact_indicator(
      cube = acacia_cube,
      impact_data = eicat_acacia,
      col_category = "impact_category",
      col_species = "scientific_name",
      col_mechanism = "impact_mechanism",
      trans = "a",
      method = "mean_cum"
    ),
    "`trans` must be a number from 1,2 or 3
i see the function documentation for details"
  )


  expect_error(compute_impact_indicator(
    cube = acacia_cube,
    impact_data = "a",
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    method = "mean_cum"
  ))

  expect_error(compute_impact_indicator(
    cube = "a",
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    method = "mean_cum"
  ))

  expect_error(compute_impact_indicator(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    method = "mean_cum",
    ci_type = "a"
  ))
})
