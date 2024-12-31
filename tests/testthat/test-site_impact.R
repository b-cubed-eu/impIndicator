# Define cube (required)
acacia_cube <- taxa_cube(
  taxa = taxa_Acacia,
  region = southAfrica_sf,
  res = 0.25,
  first_year = 2010
)

test_that("site impact function works", {
  expect_no_error(site_impact(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    type = "precautionary cumulative"
  ))

  expect_no_error(site_impact(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 2,
    type = "precautionary cumulative"
  ))

  expect_no_error(site_impact(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 3,
    type = "precautionary cumulative"
  ))

  expect_no_error(site_impact(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    type = "precautionary"
  ))
  expect_no_error(site_impact(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    type = "cumulative"
  ))

  expect_no_error(site_impact(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    type = "mean cumulative"
  ))

  expect_no_error(site_impact(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    type = "mean"
  ))
})

test_that("site impact throws errors", {
  expect_error(
    site_impact(
      cube = "a",
      impact_data = eicat_acacia,
      col_category = "impact_category",
      col_species = "scientific_name",
      col_mechanism = "impact_mechanism",
      trans = 1,
      type = "precautionary cumulative"
    )
  )

  expect_error(
    site_impact(
      cube = acacia_cube,
      impact_data = 1,
      col_category = "impact_category",
      col_species = "scientific_name",
      col_mechanism = "impact_mechanism",
      trans = 1,
      type = "precautionary cumulative"
    ),
    "`impact_data` must be a <dataframe>"
  )


  expect_error(
    site_impact(
      cube = acacia_cube,
      impact_data = "a",
      col_category = "impact_category",
      col_species = "scientific_name",
      col_mechanism = "impact_mechanism",
      trans = 1,
      type = "precautionary cumulative"
    ),
    "`impact_data` must be a <dataframe>"
  )


  expect_error(site_impact(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = NULL,
    col_species = "scientific_name",
    col_mechanism = "impact_mechanism",
    trans = 1,
    type = "precautionary cumulative"
  ))

  expect_error(site_impact(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = NULL,
    col_mechanism = "impact_mechanism",
    trans = 1,
    type = "precautionary cumulative"
  ))


  expect_error(site_impact(
    cube = acacia_cube,
    impact_data = eicat_acacia,
    col_category = "impact_category",
    col_species = "scientific_name",
    col_mechanism = NULL,
    trans = 1,
    type = "precautionary cumulative"
  ))

  expect_error(
    site_impact(
      cube = acacia_cube,
      impact_data = eicat_acacia,
      col_category = "impact_category",
      col_species = "scientific_name",
      col_mechanism = "impact_mechanism",
      trans = "a",
      type = "precautionary cumulative"
    ),
    "`trans` must be a number from 1,2 or 3
i see the function documentation for details"
  )

  expect_error(
    site_impact(
      cube = acacia_cube,
      impact_data = eicat_acacia,
      col_category = "impact_category",
      col_species = "scientific_name",
      col_mechanism = "impact_mechanism",
      trans = 1,
      type = "a"
    ),
    "`type` is not valid
x `type` must be from the options provided
See the function desciption or double check the spelling"
  )
#
#   expect_error(
#     site_impact(
#       cube = acacia_cube,
#       impact_data = eicat_acacia,
#       col_category = "impact_category",
#       col_species = "scientific_name",
#       col_mechanism = "impact_mechanism",
#       trans = 1,
#       type = "precautionary cumulative"
#     ),
#     "coords` must be a <dataframe> with columns `siteID`,`X` and `Y`"
#   )
})
