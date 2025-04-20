test_that("taxa cube function works", {
  result <- taxa_cube(taxa = taxa_Acacia,
                         region = southAfrica_sf,
                         res = 0.25,
                         first_year = 2010)


  expect_equal(class(result), "sim_cube")

  expect_no_error(taxa_cube(taxa = taxa_Acacia,
                            region = "South Africa",
                            res = 0.25,
                            first_year = 2010))

})

test_that(" taxa_cube expect errors", {

  expect_error(taxa_cube(taxa = "a",
                         region = southAfrica_sf,
                         res = 0.25,
                         first_year = 2010,
                         last_year = 2020))


  expect_error(taxa_cube(taxa = taxa_Acacia,
                         region = "a",
                         res = 0.25,
                         first_year = 2010,
                         last_year = 2020))

  expect_error(taxa_cube(taxa = taxa_Acacia,
                         region = southAfrica_sf,
                         res = "a",
                         first_year = 2010,
                         last_year = 2020))

  expect_error(taxa_cube(taxa = taxa_Acacia,
                         region = southAfrica_sf,
                         res = 0.25,
                         first_year = "a",
                         last_year = 2020))
  expect_error(taxa_cube(taxa = taxa_Acacia,
                         region = southAfrica_sf,
                         res = 0.25,
                         first_year = 2010,
                         last_year = "a"))

  #test taxa object
  expect_error(taxa_cube(taxa = 123,
                         region = southAfrica_sf,
                         res = 0.25,
                         first_year = 2010,
                         last_year = 2020),
               "`taxa` is not a character or dataframe")



  # test missing required column from taxa

  taxa_no_decimalLatitude <- taxa_Acacia %>%
    dplyr::select(-decimalLatitude)

  expect_error(taxa_cube(taxa = taxa_no_decimalLatitude,
                         region = southAfrica_sf,
                         res = 0.25,
                         first_year = 2010),
               "`decimalLatitude` is not in `taxa` column
x `taxa` should be a data of GBIF format")


})
