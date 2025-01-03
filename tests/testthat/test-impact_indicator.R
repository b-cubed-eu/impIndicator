# Define cube
acacia_cube <- taxa_cube(
  taxa = taxa_Acacia,
  region = southAfrica_sf,
  res = 0.25,
  first_year = 2010
)

test_that("impact indicator function return correct result", {
  result <- impact_indicator(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    type = "mean cumulative"
  )

  expect_equal(class(result), c("impact_indicator", "data.frame"))

  expect_equal(unique(acacia_cube$data$year), result[, 1])

  expect_no_error(result)

  expect_no_error(impact_indicator(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    type = "mean cumulative"
  ))

  expect_no_error(impact_indicator(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    type = "mean"
  ))

  expect_no_error(impact_indicator(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    type = "cumulative"
  ))


  expect_no_error(impact_indicator(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    type = "precautionary cumulative"
  ))

  expect_no_error(impact_indicator(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    type = "precautionary"
  ))
})

test_that("impact indicator function returns errors", {
  expect_error(impact_indicator(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    type = "a"
  ))

  expect_error(
    impact_indicator(
      cube = acacia_cube,
      impact_data = eicat_acacia,
      col_category = "impact_category",
      col_species = "scientific_name",
      col_mechanism = "impact_mechanism",
      trans = "a",
      type = "mean cumulative"
    ),
    "`trans` must be a number from 1,2 or 3
i see the function documentation for details"
  )

  expect_error(impact_indicator(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "a",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    type = "mean cumulative"
  ))

  expect_error(impact_indicator(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "a",
    col_mechanism = "impact_mechanism",
    trans = 1,
    type = "mean cumulative"
  ))

  expect_error(impact_indicator(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "a",
    trans = 1,
    type = "mean cumulative"
  ))

  expect_error(impact_indicator(
    cube = acacia_cube,
    impact_data = "a",
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    type = "mean cumulative"
  ))

  expect_error(impact_indicator(
    cube = "a",
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    type = "mean cumulative"
  ))
})
