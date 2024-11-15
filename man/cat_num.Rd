% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/impact_category.R
\name{cat_num}
\alias{cat_num}
\title{Convert EICAT categories to numerical values}
\usage{
cat_num(cat, trans)
}
\arguments{
\item{cat}{The EICAT impct category. (e.g., "MC)}

\item{trans}{Numeric. The type of transformation to convert the EICAT categories to
numerical values. 1 converts ("MC", "MN", "MO", "MR", "MV") to (0,1,2,3,4)
2 converts ("MC", "MN", "MO", "MR", "MV") to (1,2,3,4,5) and
3 converts ("MC", "MN", "MO", "MR", "MV") to (1,10,100,1000,10000)}
}
\value{
Numerical values corresponding to the EICAT  base on a tranfomation
}
\description{
Convert EICAT categories to numerical values
}
