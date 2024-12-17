

test_that("impact indicator function return correct result", {
  acacia_cube<-taxa_cube(taxa=taxa_Acacia,
                         region=southAfrica_sf,
                         res=0.25,
                         first_year=2010)


  result<-impact_indicator(cube=acacia_cube$cube,
                              impact_data = eicat_data,
                              col_category="impact_category",
                              col_species="scientific_name",
                              col_mechanism="impact_mechanism",
                              trans=1,
                              type = "mean cumulative")

  expect_equal(class(result), c("impact_indicator","data.frame"))

  expect_equal(unique(acacia_cube$cube$data$year),result[,1])

  expect_no_error(result)

})

test_that("impact indicator function returns errors",{

  expect_error(impact_indicator(cube=acacia_cube$cube,
                                impact_data = eicat_data,
                                col_category="impact_category",
                                col_species="scientific_name",
                                col_mechanism="impact_mechanism",
                                trans=1,
                                type = "a"))

  expect_error(impact_indicator(cube=acacia_cube$cube,
                                impact_data = eicat_data,
                                col_category="impact_category",
                                col_species="scientific_name",
                                col_mechanism="impact_mechanism",
                                trans="a",
                                type = "mean cumulative"))

  expect_error(impact_indicator(cube=acacia_cube$cube,
                                impact_data = eicat_data,
                                col_category="a",
                                col_species="scientific_name",
                                col_mechanism="impact_mechanism",
                                trans=1,
                                type = "mean cumulative"))

  expect_error(impact_indicator(cube=acacia_cube$cube,
                                impact_data = eicat_data,
                                col_category="impact_category",
                                col_species="a",
                                col_mechanism="impact_mechanism",
                                trans=1,
                                type = "mean cumulative"))

  expect_error(impact_indicator(cube=acacia_cube$cube,
                                impact_data = eicat_data,
                                col_category="impact_category",
                                col_species="scientific_name",
                                col_mechanism="a",
                                trans=1,
                                type = "mean cumulative"))

  expect_error(impact_indicator(cube=acacia_cube$cube,
                                impact_data = "a",
                                col_category="impact_category",
                                col_species="scientific_name",
                                col_mechanism="impact_mechanism",
                                trans=1,
                                type = "mean cumulative"))

  expect_error(impact_indicator(cube="a",
                                impact_data = eicat_data,
                                col_category="impact_category",
                                col_species="scientific_name",
                                col_mechanism="impact_mechanism",
                                trans=1,
                                type = "mean cumulative"))

})
