# Define cube (required)
acacia_cube <- taxa_cube(
  taxa = taxa_Acacia,
  region = southAfrica_sf,
  res = 0.25,
  first_year = 2010
)

test_that("site impact function works", {
  expect_no_error(compute_impact_per_site(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    method = "precaut_cum"
  ))

  expect_no_error(compute_impact_per_site(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 2,
    method = "precaut_cum"
  ))

  expect_no_error(compute_impact_per_site(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 3,
    method = "precaut_cum"
  ))

  expect_no_error(compute_impact_per_site(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    method = "precaut"
  ))
  expect_no_error(compute_impact_per_site(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    method = "cum"
  ))

  expect_no_error(compute_impact_per_site(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    method = "mean_cum"
  ))

  expect_no_error(compute_impact_per_site(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    method = "mean"
  ))
})

test_that("site impact throws errors", {
  expect_error(
    compute_impact_per_site(
      cube = "a",
      impact_data = eicat_acacia,
      col_category = "impact_category",
      col_species = "scientific_name",
      col_mechanism = "impact_mechanism",
      trans = 1,
      method = "precaut_cum"
    )
  )

  expect_error(
    compute_impact_per_site(
      cube = acacia_cube,
      impact_data = 1,
      col_category = "impact_category",
      col_species = "scientific_name",
      col_mechanism = "impact_mechanism",
      trans = 1,
      method = "precaut_cum"
    ),
    "`impact_data` must be a <dataframe>"
  )


  expect_error(
    compute_impact_per_site(
      cube = acacia_cube,
      impact_data = "a",
      col_category = "impact_category",
      col_species = "scientific_name",
      col_mechanism = "impact_mechanism",
      trans = 1,
      method = "precaut_cum"
    ),
    "`impact_data` must be a <dataframe>"
  )

  expect_error(
    compute_impact_per_site(
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

  expect_error(
    compute_impact_per_site(
      cube = acacia_cube,
      impact_data = eicat_acacia,
      col_category = "impact_category",
      col_species = "scientific_name",
      col_mechanism = "impact_mechanism",
      trans = 1,
      method = "a"
    ),
    "`method` is not valid
x `method` must be from the options provided
See the function desciption or double check the spelling"
  )

})
