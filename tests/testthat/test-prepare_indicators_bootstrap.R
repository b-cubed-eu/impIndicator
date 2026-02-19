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

# --------------------------------------------------
# Basic functionality
# --------------------------------------------------

test_that("prepare_indicators_bootstrap returns structured parameter lists overall", {

  params <- prepare_indicators_bootstrap(
    impact_cube_data = impact_cube,
    indicator = "overall",
    indicator_method = "mean_cum"
  )

  expect_type(params, "list")
  expect_named(params, c("bootstrap_params", "ci_params", "cv_params"))

  expect_type(params$bootstrap_params, "list")
  expect_type(params$ci_params, "list")
  expect_type(params$cv_params, "list")

  # Check key bootstrap elements
  expect_equal(params$bootstrap_params$data_cube, impact_cube)
  expect_equal(params$bootstrap_params$indicator_method, "mean_cum")
  expect_equal(params$bootstrap_params$method, "whole_cube")

  # Default bootstrap values
  expect_equal(params$bootstrap_params$samples, 1000)
  expect_true(is.na(params$bootstrap_params$seed))

  # Default CI values
  expect_equal(params$ci_params$type, "perc")
  expect_equal(params$ci_params$conf, 0.95)
  expect_true(params$ci_params$no_bias)

})

# --------------------------------------------------
# boot_args override defaults
# --------------------------------------------------

test_that("boot_args override defaults correctly", {

  params <- prepare_indicators_bootstrap(
    impact_cube_data = impact_cube,
    indicator = "overall",
    indicator_method = "mean_cum",
    boot_args = list(samples = 2000, seed = 123)
  )

  expect_equal(params$bootstrap_params$samples, 2000)
  expect_equal(params$bootstrap_params$seed, 123)

})

# --------------------------------------------------
# boot_args allow additional arguments
# --------------------------------------------------

test_that("boot_args allow additional arguments", {

  params <- prepare_indicators_bootstrap(
    impact_cube_data = impact_cube,
    indicator = "overall",
    indicator_method = "mean_cum",
    boot_args = list(resample_level = "species")
  )

  expect_equal(params$bootstrap_params$resample_level, "species")

})

# --------------------------------------------------
# ci_args override defaults
# --------------------------------------------------

test_that("ci_args override defaults correctly", {

  params <- prepare_indicators_bootstrap(
    impact_cube_data = impact_cube,
    indicator = "overall",
    indicator_method = "mean_cum",
    ci_args = list(no_bias = FALSE)
  )

  expect_false(params$ci_params$no_bias)

})

# --------------------------------------------------
# confidence_level is respected
# --------------------------------------------------

test_that("confidence_level correctly sets conf", {

  params <- prepare_indicators_bootstrap(
    impact_cube_data = impact_cube,
    indicator = "overall",
    indicator_method = "mean_cum",
    confidence_level = 0.9
  )

  expect_equal(params$ci_params$conf, 0.9)

})

# --------------------------------------------------
# Invalid indicator types
# --------------------------------------------------

test_that("prepare_indicators_bootstrap throws error for unsupported indicators", {

  expect_error(
    prepare_indicators_bootstrap(
      impact_cube_data = impact_cube,
      indicator = "site",
      indicator_method = "mean_cum"
    ),
    "indicator not implemented yet"
  )

  expect_error(
    prepare_indicators_bootstrap(
      impact_cube_data = impact_cube,
      indicator = "species",
      indicator_method = "mean_cum"
    ),
    "indicator not implemented yet"
  )

})

# --------------------------------------------------
# Invalid indicator value
# --------------------------------------------------

test_that("invalid indicator value throws error", {

  expect_error(
    prepare_indicators_bootstrap(
      impact_cube_data = impact_cube,
      indicator = "invalid",
      indicator_method = "mean_cum"
    )
  )

})

# --------------------------------------------------
# Invalid impact_cube_data class
# --------------------------------------------------

test_that("invalid impact_cube_data throws error", {

  expect_error(
    prepare_indicators_bootstrap(
      impact_cube_data = acacia_cube,  # wrong class
      indicator = "overall",
      indicator_method = "mean_cum"
    ),
    "must be an impact cube object"
  )

})
