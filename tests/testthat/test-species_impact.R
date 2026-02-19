library(b3gbi)

# Example test cube
acacia_cube <- taxa_cube(
  taxa = taxa_Acacia,
  region = southAfrica_sf,
  res = 0.25,
  first_year = 2010
)

test_that("compute_impact_per_species works without CI", {

  res <- compute_impact_per_species(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    method = "mean",
    trans = 1,
    ci_type = "none",
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism"
  )

  expect_s3_class(res, "species_impact")
  expect_true(all(c("method","num_species","names_species","species_impact") %in% names(res)))
  expect_true(is.data.frame(res$species_impact))
  expect_equal(unique(res$method), "mean")
})

test_that("compute_impact_per_species works for all methods and trans", {

  for (m in c("mean","max","max_mech")) {
    for (t in 1:3) {
      expect_silent(
        compute_impact_per_species(
          cube = acacia_cube,
          impact_data = eicat_acacia,
          method = m,
          trans = t,
          ci_type = "none",
          col_category = "impact_category",
          col_species = "scientific_name",
          col_mechanism = "impact_mechanism"
        )
      )
    }
  }
})

test_that("compute_impact_per_species throws error for invalid inputs", {

  # invalid cube
  expect_error(
    compute_impact_per_species(
      cube = "invalid_cube",
      impact_data = eicat_acacia,
      method = "mean",
      ci_type = "none",
      col_category = "impact_category",
      col_species = "scientific_name",
      col_mechanism = "impact_mechanism"
    )
  )

  # invalid impact_data
  expect_error(
    compute_impact_per_species(
      cube = acacia_cube,
      impact_data = "invalid_data",
      method = "mean",
      ci_type = "none",
      col_category = "impact_category",
      col_species = "scientific_name",
      col_mechanism = "impact_mechanism"
    )
  )

  # invalid method
  expect_error(
    compute_impact_per_species(
      cube = acacia_cube,
      impact_data = eicat_acacia,
      method = "invalid_method",
      ci_type = "none",
      col_category = "impact_category",
      col_species = "scientific_name",
      col_mechanism = "impact_mechanism"
    )
  )

  # invalid trans
  expect_error(
    compute_impact_per_species(
      cube = acacia_cube,
      impact_data = eicat_acacia,
      method = "mean",
      trans = "a",
      ci_type = "none",
      col_category = "impact_category",
      col_species = "scientific_name",
      col_mechanism = "impact_mechanism"
    )
  )

  # bootstrapping
  expect_error(
    compute_impact_per_species(
      cube = acacia_cube,
      impact_data = eicat_acacia,
      method = "mean",
      ci_type = "perc",
      col_category = "impact_category",
      col_species = "scientific_name",
      col_mechanism = "impact_mechanism"
    )
  )
})
