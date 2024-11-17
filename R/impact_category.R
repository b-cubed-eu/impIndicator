#' Compute impact categories
#'
#' @description
#' Aggregate species impact categories from impact data.
#'
#' @param impact_data The dataframe of species impact which contains columns of category,
#'  species and mechanism.
#' @param species_list The vector of species' list to aggregate their impact categories
#' @param col_category The name of the column containing the impact categories.
#' The first two letters each categories must be an EICAT short names
#' (e.g "MC -Minimal concern")
#' @param col_species The name of the column containing species names
#' @param col_mechanism The name of the column containing mechanisms of impact
#' @param trans Numeric. The type of transformation to convert the EICAT categories to
#' numerical values. 1 converts ("MC", "MN", "MO", "MR", "MV") to (0,1,2,3,4)
#' 2 converts ("MC", "MN", "MO", "MR", "MV") to (1,2,3,4,5) and
#' 3 converts ("MC", "MN", "MO", "MR", "MV") to (1,10,100,1000,10000)
#'
#' @return The dataframe containing the aggregated species impact. max - maximum
#' impact of a species. mean - mean impact of a species. max_mech - sum of maximum
#' impact per categories of a species
#' @export
#'
#' @examples
#' #read the impact data
#' #eicat_data<-readRDS("data/eicat_data.rds")
#' #define species list
#' species_list<-c("Acacia adunca",
#' "Acacia baileyana",
#' "Acacia binervata",
#' "Acacia crassiuscula",
#' "Acacia cultriformis",
#' "Acacia cyclops",
#' "Acacia dealbata",
#' "Acacia decurrens",
#' "Acacia elata")
#'
#' agg_impact<-impact_cat(impact_data=eicat_data,
#'                      species_list=species_list,
#'                      col_category="impact_category",
#'                      col_species="scientific_name",
#'                      col_mechanism="impact_mechanism",
#'                      trans=1)
#'
impact_cat<-function(impact_data,
                     species_list,
                     col_category=NULL,
                     col_species=NULL,
                     col_mechanism=NULL,
                     trans=1){


  if(all(c("category",
           "species",
           "mechanism")%in%names(impact_data))){
    impact_data<-impact_data
  } else if(all(c(!is.null(col_category),
                  !is.null(col_species),
                  !is.null(col_mechanism)))){
    impact_data <- impact_data %>%
      dplyr::rename(dplyr::all_of(c(category=col_category,
                      species=col_species,
                      mechanism=col_mechanism)))

  } else{ stop("category, species and mechanism are not found in  impact_data. col_category and col_species must be given")}

  category_max_mean <- impact_data %>%
    dplyr::mutate(category = substr(category, 1, 2)) %>%
    dplyr::filter(category %in% c("MC", "MN", "MO", "MR", "MV")) %>%
    dplyr::select(species, mechanism, category) %>%
    dplyr::mutate(category_value=cat_num(category,trans)) %>%
    dplyr::distinct(species, mechanism, category,
                    .keep_all = TRUE) %>%
    dplyr::group_by(species) %>%
    dplyr::summarise(
      max_value = max(category_value, na.rm = TRUE),
      mean_value = mean(category_value, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    dplyr::filter(species %in% species_list)


  category_sum_mech = impact_data %>%
    dplyr::mutate(category=substr(category,1,2)) %>%
    dplyr::filter(category %in% c("MC","MN","MO","MR","MV")) %>%
    dplyr::select(species,mechanism,category) %>%
    dplyr::mutate(category_value=cat_num(category,trans)) %>%
    dplyr::distinct(species,mechanism,category,
                    .keep_all = TRUE) %>%

    dplyr::group_by(species,mechanism) %>%
    dplyr::summarise(dplyr::across(category_value,max),
                     .groups = "drop") %>%
    dplyr::group_by(species) %>%
    dplyr::summarise(dplyr::across(category_value,sum),
                     .groups = "drop") %>%
    dplyr::filter(species %in% species_list)

  category_M<-dplyr::left_join(category_max_mean,category_sum_mech,
                               by=dplyr::join_by(species)) %>%
    tibble::column_to_rownames(var = "species")

  names(category_M)<-c("max","mean","max_mech")

  impact_matrix<-category_M

  na.df<-as.data.frame(matrix(NA,
                              nrow = length(setdiff(species_list,
                                                    rownames(impact_matrix))),
                              ncol = ncol(impact_matrix)))
  row.names(na.df)<-setdiff(species_list,rownames(impact_matrix))
  names(na.df)<-names(impact_matrix) # column names
  impact_matrix<-rbind(impact_matrix,na.df)


  impact_matrix <- impact_matrix %>%
    dplyr::mutate(rowname = row.names(.)) %>%
    dplyr::arrange(rowname) %>%
    dplyr::select(-rowname)

  return(impact_matrix)
}

