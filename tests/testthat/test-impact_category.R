
# test with unmatched eicat column names
unmatched_eicat <- eicat_acacia %>%
  dplyr::rename(c(
    category = "impact_category",
    species = "scientific_name",
    mechanism = "impact_mechanism"
  ))

test_that("impact cat function works", {

  species_list <- sort(unique(taxa_Acacia$species))

  expect_no_error(impact_cat(
    impact_data = eicat_acacia,
    species_list = species_list,
    trans = 1
  ))

  expect_no_error(impact_cat(
    impact_data = eicat_acacia,
    species_list = species_list,
    trans = 2
  ))

  expect_no_error(impact_cat(
    impact_data = eicat_acacia,
    species_list = species_list,
    trans = 3
  ))

  # test output format
  result <- impact_cat(
    impact_data = eicat_acacia,
    species_list = species_list,
    trans = 1
  )

  expect_equal(rownames(result), species_list)

  expect_named(result)

  expect_no_error(impact_cat(
    impact_data = unmatched_eicat,
    species_list = species_list,
    col_category = "category",
    col_species = "species",
    col_mechanism = "mechanism",
    trans = 1
  ))
})


test_that("impact cat function throws error", {
  species_list <- sort(unique(taxa_Acacia$species))


  # impact_data is not the expected format
  expect_error(
    impact_cat(
      impact_data = "a",
      species_list = species_list,
      col_category = "impact_category",
      col_species = "scientific_name",
      col_mechanism = "impact_mechanism",
      trans = 3
    ),
    "`impact_data` must be a <dataframe>"
  )

  # species is not expected structure
  expect_error(
    impact_cat(
      impact_data = eicat_acacia,
      species_list = 1,
      trans = 3
    ),
    "`species_list` must be a <character>"
  )

  expect_error(
    impact_cat(
      impact_data = unmatched_eicat,
      species_list = species_list,
      col_category = NULL,
      col_species = "scientific_name",
      col_mechanism = "impact_mechanism",
      trans = 3
    ),
    paste("columns `impact_category`, `scientific_name` and `impact_mechanism`",
          "are not found in the `impact_data`
i columns `col_category`, `col_species` and `col_mechanism` must all be given")
  )


  expect_error(
    impact_cat(
      impact_data = unmatched_eicat,
      species_list = species_list,
      col_category = "scientific_name",
      col_species = NULL,
      col_mechanism = "impact_mechanism",
      trans = 3
    ),
    paste("columns `impact_category`, `scientific_name` and `impact_mechanism`",
          "are not found in the `impact_data`
i columns `col_category`, `col_species` and `col_mechanism` must all be given")
  )


  expect_error(
    impact_cat(
      impact_data = unmatched_eicat,
      species_list = species_list,
      col_category = "scientific_name",
      col_species = "scientific_name",
      col_mechanism = NULL,
      trans = 3
    ),
    paste("columns `impact_category`, `scientific_name` and `impact_mechanism`",
          "are not found in the `impact_data`
i columns `col_category`, `col_species` and `col_mechanism` must all be given")
  )

  expect_error(
    impact_cat(
      impact_data = eicat_acacia,
      species_list = species_list,
      trans = "a"
    ),
    "`trans` must be a number from 1,2 or 3
i see the function documentation for details"
  )
})
