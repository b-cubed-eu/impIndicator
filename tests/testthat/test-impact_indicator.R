# Define cube
library(b3gbi)

acacia_cube <- process_cube(
  cube_name = cube_acacia_SA,
  grid_type = "eqdgc",
  first_year = 2010,
  last_year = 2024
)

impact_cube <- create_impact_cube_data(
  cube_data = acacia_cube$data,
  impact_data = eicat_acacia
)

test_that("compute_impact_indicator returns correct structure without CI", {

  result <- compute_impact_indicator(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    method = "mean_cum",
    trans = 1,
    ci_type = "none"
  )

  expect_s3_class(result, "impact_indicator")

  expect_named(
    result,
    c("method", "num_cells", "num_species", "names_species", "impact")
  )

  expect_equal(result$method, "mean_cum")
  expect_true(is.numeric(result$num_cells))
  expect_true(is.numeric(result$num_species))
  expect_true(is.character(result$names_species))

  expect_true(is.data.frame(result$impact))

})

test_that("compute_impact_indicator works with bootstrap CI", {

  result <- compute_impact_indicator(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    method = "mean_cum",
    trans = 1,
    ci_type = "perc",
    boot_args = list(samples = 50)  # small for speed
  )

  expect_s3_class(result, "impact_indicator")

  expect_true(is.data.frame(result$impact))

  # CI output should contain CI columns
  expect_true(any(grepl("ll", names(result$impact))))
  expect_true(any(grepl("ul", names(result$impact))))

})

test_that("all aggregation methods run without CI", {

  methods <- c("mean_cum", "mean", "cum", "precaut", "precaut_cum")

  for (m in methods) {

    expect_no_error(
      compute_impact_indicator(
        cube = acacia_cube,
        impact_data = eicat_acacia,
        col_category = "impact_category",
        col_species = "scientific_name",
        col_mechanism = "impact_mechanism",
        method = m,
        trans = 1,
        ci_type = "none"
      )
    )

  }

})

test_that("works when cube is a data.frame", {

  expect_no_error(
    compute_impact_indicator(
      cube = acacia_cube$data,
      impact_data = eicat_acacia,
      col_category = "impact_category",
      col_species = "scientific_name",
      col_mechanism = "impact_mechanism",
      method = "mean_cum",
      trans = 1,
      ci_type = "none"
    )
  )

})

test_that("works when cube already contains impact data", {

  expect_no_error(
    compute_impact_indicator(
      cube = impact_cube,
      method = "precaut",
      ci_type = "none"
    )
  )

})

test_that("region argument works when provided", {

  expect_no_error(
    compute_impact_indicator(
      cube = acacia_cube,
      impact_data = eicat_acacia,
      col_category = "impact_category",
      col_species = "scientific_name",
      col_mechanism = "impact_mechanism",
      method = "precaut",
      trans = 1,
      region = southAfrica_sf,
      ci_type = "none"
    )
  )

})

test_that("invalid method throws error", {

  expect_error(
    compute_impact_indicator(
      cube = acacia_cube,
      impact_data = eicat_acacia,
      col_category = "impact_category",
      col_species = "scientific_name",
      col_mechanism = "impact_mechanism",
      method = "invalid",
      trans = 1,
      ci_type = "none"
    ),
    "method"
  )

})

test_that("invalid cube class throws error", {

  expect_error(
    compute_impact_indicator(
      cube = "not_a_cube",
      impact_data = eicat_acacia,
      method = "mean_cum",
      trans = 1,
      ci_type = "none"
    ),
    "must be a class"
  )

})

test_that("invalid ci_type throws error", {

  expect_error(
    compute_impact_indicator(
      cube = acacia_cube,
      impact_data = eicat_acacia,
      col_category = "impact_category",
      col_species = "scientific_name",
      col_mechanism = "impact_mechanism",
      method = "mean_cum",
      trans = 1,
      ci_type = "invalid"
    )
  )

})

test_that("invalid region throws error", {

  expect_error(
    compute_impact_indicator(
      cube = acacia_cube,
      impact_data = eicat_acacia,
      col_category = "impact_category",
      col_species = "scientific_name",
      col_mechanism = "impact_mechanism",
      method = "mean_cum",
      trans = 1,
      region = "not_sf",
      ci_type = "none"
    ),
    "region"
  )

})
