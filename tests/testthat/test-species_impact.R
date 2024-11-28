acacia_cube<-taxa_cube(taxa=taxa_Acacia,
                       region=southAfrica_sf,
                       res=0.25,
                       first_year=2010)

test_that("species impact function works", {
  expect_no_error(species_impact(cube=acacia_cube$cube,
                                 impact_data = eicat_data,
                                 col_category="impact_category",
                                 col_species="scientific_name",
                                 col_mechanism="impact_mechanism",
                                 trans=1,
                                 type = "mean"))

  expect_no_error(species_impact(cube=acacia_cube$cube,
                                 impact_data = eicat_data,
                                 col_category="impact_category",
                                 col_species="scientific_name",
                                 col_mechanism="impact_mechanism",
                                 trans=2,
                                 type = "mean"))

  expect_no_error(species_impact(cube=acacia_cube$cube,
                                 impact_data = eicat_data,
                                 col_category="impact_category",
                                 col_species="scientific_name",
                                 col_mechanism="impact_mechanism",
                                 trans=3,
                                 type = "mean"))

  expect_no_error(species_impact(cube=acacia_cube$cube,
                                 impact_data = eicat_data,
                                 col_category="impact_category",
                                 col_species="scientific_name",
                                 col_mechanism="impact_mechanism",
                                 trans=1,
                                 type = "max"))

  expect_no_error(species_impact(cube=acacia_cube$cube,
                                 impact_data = eicat_data,
                                 col_category="impact_category",
                                 col_species="scientific_name",
                                 col_mechanism="impact_mechanism",
                                 trans=1,
                                 type = "max_mech"))


})

test_that("species impact function throws error",{
  expect_error(species_impact(cube="a",
                                 impact_data = eicat_data,
                                 col_category="impact_category",
                                 col_species="scientific_name",
                                 col_mechanism="impact_mechanism",
                                 trans=1,
                                 type = "mean"))


  expect_error(species_impact(cube=acacia_cube$cube,
                              impact_data = "a",
                              col_category="impact_category",
                              col_species="scientific_name",
                              col_mechanism="impact_mechanism",
                              trans=1,
                              type = "mean"))

  expect_error(species_impact(cube=acacia_cube$cube,
                              impact_data = eicat_data,
                              col_category=NULL,
                              col_species="scientific_name",
                              col_mechanism="impact_mechanism",
                              trans=1,
                              type = "mean"))


  expect_error(species_impact(cube=acacia_cube$cube,
                                 impact_data = eicat_data,
                                 col_category="impact_category",
                                 col_species=NULL,
                                 col_mechanism="impact_mechanism",
                                 trans=1,
                                 type = "mean"))

  expect_error(species_impact(cube=acacia_cube$cube,
                              impact_data = eicat_data,
                              col_category="impact_category",
                              col_species="scientific_name",
                              col_mechanism=NULL,
                              trans=1,
                              type = "mean"))


  expect_error(species_impact(cube=acacia_cube$cube,
                              impact_data = eicat_data,
                              col_category="impact_category",
                              col_species="scientific_name",
                              col_mechanism="impact_mechanism",
                              trans="a",
                              type = "mean"))


  expect_error(species_impact(cube=acacia_cube$cube,
                              impact_data = eicat_data,
                              col_category="impact_category",
                              col_species="scientific_name",
                              col_mechanism="impact_mechanism",
                              trans=1,
                              type = "a"))
})
