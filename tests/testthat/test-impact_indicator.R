

test_that("impact_indicator function return correct class", {
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

  expect_equal(class(result), "data.frame")

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
