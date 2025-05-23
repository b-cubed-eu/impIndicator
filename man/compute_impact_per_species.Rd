% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/species_impact.R
\name{compute_impact_per_species}
\alias{compute_impact_per_species}
\title{Compute species impact indicator}
\usage{
compute_impact_per_species(
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
\item{cube}{The data cube of class \code{sim_cube} or
\code{processed_cube} from \code{b3gbi::process_cube()}.}

\item{impact_data}{The dataframe of species impact which contains columns of
\code{impact_category}, \code{scientific_name} and \code{impact_mechanism}.}

\item{method}{The method of computing the indicator.
The method used in the aggregation of within impact of species.
The method can be
\itemize{
\item \code{"max"}:The maximum method assigns a species the maximum impact across all
records of the species. It is best for precautionary approaches.
Also, the assumption is that the management of the highest impact can
cover for the lower impact caused by a species and can be the best
when there is low confidence in the multiple impacts of species of interest.
However, the maximum method can overestimate the impact of a species
especially when the highest impact requires specific or rare conditions and
many lower impacts were recorded.
\item \code{"mean"}: assigns a species the mean impact of all the species impact.
This method computes the expected impact of the species considering
all species impact without differentiating between
impacts. This method is adequate when there are many
impact records per species.
\item \code{"max_mech"}: Assigns a species the summation of the maximum impact
per mechanism. The assumption is that species with
many mechanisms of impact have a higher potential to cause impact.
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
A dataframe of impact indicator per species (class \code{species_impact}).
}
\description{
Combines occurrences cube and impact data using the given method
(e.g., mean) to compute the impact indicator per species.
}
\examples{
acacia_cube <- taxa_cube(
  taxa = taxa_Acacia,
  region = southAfrica_sf,
  res = 0.25,
  first_year = 2010
)

speciesImpact <- compute_impact_per_species(
  cube = acacia_cube,
  impact_data = eicat_acacia,
  method = "mean",
  trans = 1
)
}
\seealso{
Other Indicator function: 
\code{\link{compute_impact_indicator}()},
\code{\link{compute_impact_per_site}()}
}
\concept{Indicator function}
