
library(b3gbi) # for processing cube
acacia_cube <- process_cube(cube_name = cube_acacia_SA,
                          grid_type = "eqdgc",
                          first_year = 2010,
                           last_year = 2024)

test_that("create_impact_cube_data works", {

  expect_no_error(
    create_impact_cube_data(
      cube_data = acacia_cube,
      impact_data = eicat_acacia,
      col_category = NULL,
      col_species = NULL,
      col_mechanism = NULL,
      region = NULL
    )
  )

  expect_no_error(
    create_impact_cube_data(
      cube_data = acacia_cube$data,
      impact_data = eicat_acacia,
      col_category = NULL,
      col_species = NULL,
      col_mechanism = NULL,
      region = NULL
    )
  )

  expect_no_error(
    create_impact_cube_data(
      cube_data = acacia_cube,
      impact_data = eicat_acacia,
      col_category = NULL,
      col_species = NULL,
      col_mechanism = NULL,
      region = southAfrica_sf
    )
  )

  impact_value<-create_impact_cube_data(
    cube_data = acacia_cube,
    impact_data = eicat_acacia,
    col_category = NULL,
    col_species = NULL,
    col_mechanism = NULL,
    region = NULL
  )
  expect_all_true(class(impact_value)==c("impact_cube","tbl_df","tbl","data.frame"))
})
