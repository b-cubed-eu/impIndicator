% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/site_impact.R
\name{compute_impact_per_site}
\alias{compute_impact_per_site}
\title{Site impact indicator}
\usage{
compute_impact_per_site(
  cube,
  impact_data = NULL,
  method = NULL,
  trans = 1,
  col_category = NULL,
  col_species = NULL,
  col_mechanism = NULL
)
}
\arguments{
\item{cube}{The data cube of class \code{sim_cube} or \code{processed_cube} from
\code{b3gbi::process_cube()}.}

\item{impact_data}{The dataframe of species impact which contains columns of
\code{impact_category}, \code{scientific_name} and \code{impact_mechanism}.}

\item{method}{The method of computing the indicator. The method used in
the aggregation of within and across species in a site proposed
by Boulesnane-Genguant et al. (submitted).
The method can be one of
\itemize{
\item \code{"precaut"}: The "\code{precautionary}" method assigns a species the
maximum impact across all records of the species and then compute the
maximum impact across species in each site
\item \code{"precaut_cum"}: The "\verb{precautionary cumulative}" method assigns a
species the maximum impact across all records of the species then
compute the summation of all impacts in each site.
The precautionary cumulative method provides the highest
impact score possible for each species but considers
the number of co-occurring species in each site.
\item \code{"mean"}:The "\code{mean}" method assigns species the mean impact of all
the species impact and then computes the mean of all species in each site.
The mean provides the expected impact within individual species and
across all species in each site.
\item \code{"mean_cum"}: The "\verb{mean cumulative}" assigns a species the mean
impact of all the species impact and then computes the summation of all
impact scores in each site. The mean cumulative provides the expected
impact score within individual species but adds co-occurring species’
impact scores in each site.
\item \code{"cum"}: The "\code{cumulative}" assigns a species the summation of the
maximum impact per mechanism and then computes the summation of
all species’ impacts per site. The cumulative method provides a
comprehensive view of the overall impact while considering the impact
and mechanisms of multiple species.
}}

\item{trans}{Numeric: \code{1} (default), \code{2} or \code{3}. The method of transformation
to convert the EICAT categories \code{c("MC", "MN", "MO", "MR", "MV")} to
numerical values:
\itemize{
\item \code{1}: converts the categories to \code{c(0, 1, 2, 3, 4)}
\item \code{2}: converts the categories to to \code{c(1, 2, 3, 4, 5)}
\item \code{3}: converts the categories to to \code{c(1, 10, 100, 1000, 10000)}
}}

\item{col_category}{The name of the column containing the impact categories.
The first two letters each categories must be an EICAT short names
(e.g "MC - Minimal concern").}

\item{col_species}{The name of the column containing species names.}

\item{col_mechanism}{The name of the column containing mechanisms of impact.}
}
\value{
The dataframe of impact indicator per sites (class \code{site_impact})
}
\description{
Combines occurrences cube and impact data using the given method
(e.g., mean cumulative) to compute the impact indicator per site.
}
\examples{
# define cube for taxa
acacia_cube <- taxa_cube(
  taxa = taxa_Acacia,
  region = southAfrica_sf,
  res = 0.25,
  first_year = 2010
)

siteImpact <- compute_impact_per_site(
  cube = acacia_cube,
  impact_data = eicat_acacia,
  method = "mean_cum",
  trans = 1
)
}
\seealso{
Other Indicator function: 
\code{\link{compute_impact_indicator}()},
\code{\link{compute_impact_per_species}()}
}
\concept{Indicator function}
