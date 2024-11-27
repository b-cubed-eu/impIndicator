test_that("taxa cube function works", {
  result<-taxa_cube(taxa=taxa_Acacia,
                         region=southAfrica_sf,
                         res=0.25,
                         first_year=2010)


  expect_equal(class(result),"list")

  #test scientific name
  taxa<-"acacia"
  #but expect warning because all 500 occurrences (default limit)
  #will be from recent years
  expect_warning(taxa_cube(taxa=taxa,
                            region=southAfrica_sf,
                            res=0.25))
})

test_that(" taxa cube expect errors",{



  expect_error(taxa_cube(taxa="a",
                         region=southAfrica_sf,
                         res=0.25,
                         first_year=2010))


  expect_error(taxa_cube(taxa=taxa_Acacia,
                         region="a",
                         res=0.25,
                         first_year=2010))

  expect_error(taxa_cube(taxa=taxa_Acacia,
                         region=southAfrica_sf,
                         res="a",
                         first_year=2010))

  expect_error(taxa_cube(taxa=taxa_Acacia,
                         region=southAfrica_sf,
                         res=0.25,
                         first_year="a"))
})

