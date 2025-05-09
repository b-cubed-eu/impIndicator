acacia_cube <- taxa_cube(taxa = taxa_Acacia,
                       region = southAfrica_sf,
                       res = 0.25,
                       first_year = 2010)

test_that("species impact function works", {

  result <- compute_impact_per_species(cube = acacia_cube,
                 impact_data  =  eicat_acacia,
                 col_category = "impact_category",
                 col_species = "scientific_name",
                 col_mechanism = "impact_mechanism",
                 trans = 1,
                 method  =  "mean")

  expect_equal(class(result),
               c("species_impact", "tbl_df", "tbl", "data.frame"))

  expect_no_error(result)

  expect_no_error(compute_impact_per_species(cube = acacia_cube,
                                 impact_data  =  eicat_acacia,
                                 col_category = "impact_category",
                                 col_species = "scientific_name",
                                 col_mechanism = "impact_mechanism",
                                 trans = 2,
                                 method  =  "mean"))

  expect_no_error(compute_impact_per_species(cube = acacia_cube,
                                 impact_data  =  eicat_acacia,
                                 col_category = "impact_category",
                                 col_species = "scientific_name",
                                 col_mechanism = "impact_mechanism",
                                 trans = 3,
                                 method  =  "mean"))

  expect_no_error(compute_impact_per_species(cube = acacia_cube,
                                 impact_data  =  eicat_acacia,
                                 col_category = "impact_category",
                                 col_species = "scientific_name",
                                 col_mechanism = "impact_mechanism",
                                 trans = 1,
                                 method  =  "max"))

  expect_no_error(compute_impact_per_species(cube = acacia_cube,
                                 impact_data  =  eicat_acacia,
                                 col_category = "impact_category",
                                 col_species = "scientific_name",
                                 col_mechanism = "impact_mechanism",
                                 trans = 1,
                                 method  =  "max_mech"))


})

test_that("species impact function throws error", {
  expect_error(compute_impact_per_species(cube = "a",
                                 impact_data  =  eicat_acacia,
                                 col_category = "impact_category",
                                 col_species = "scientific_name",
                                 col_mechanism = "impact_mechanism",
                                 trans = 1,
                                 method  =  "mean"))


  expect_error(compute_impact_per_species(cube = acacia_cube,
                              impact_data  =  "a",
                              col_category = "impact_category",
                              col_species = "scientific_name",
                              col_mechanism = "impact_mechanism",
                              trans = 1,
                              method  =  "mean"))

  expect_error(compute_impact_per_species(cube = acacia_cube,
                              impact_data  =  unmatched_eicat,
                              col_category = NULL,
                              col_species = "scientific_name",
                              col_mechanism = "impact_mechanism",
                              trans = 1,
                              method  =  "mean"))


  expect_error(compute_impact_per_species(cube = acacia_cube,
                                 impact_data  =  unmatched_eicat,
                                 col_category = "impact_category",
                                 col_species = NULL,
                                 col_mechanism = "impact_mechanism",
                                 trans = 1,
                                 method  =  "mean"))

  expect_error(compute_impact_per_species(cube = acacia_cube,
                              impact_data  =  unmatched_eicat,
                              col_category = "impact_category",
                              col_species = "scientific_name",
                              col_mechanism = NULL,
                              trans = 1,
                              method  =  "mean"))


  expect_error(compute_impact_per_species(cube = acacia_cube,
                              impact_data  =  eicat_acacia,
                              col_category = "impact_category",
                              col_species = "scientific_name",
                              col_mechanism = "impact_mechanism",
                              trans = "a",
                              method  =  "mean"))


  expect_error(compute_impact_per_species(cube = acacia_cube,
                              impact_data  =  eicat_acacia,
                              col_category = "impact_category",
                              col_species = "scientific_name",
                              col_mechanism = "impact_mechanism",
                              trans = 1,
                              method  =  "a"))
})
