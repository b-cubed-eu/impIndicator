# Copy of breaks_pretty from scales package
#' @noRd

breaks_pretty_int <- function(n = 5, ...) {
  force_all(n, ...)
  n_default <- n
  function(x, n = n_default) {
    breaks <- pretty(x, n, ...)
    names(breaks) <- attr(breaks, "labels")
    breaks
  }
}

# Copy of internal function force_all from scales package
#' @noRd

force_all <- function(...) {
  list(...)
}

#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr:pipe]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
#' @param lhs A value or the magrittr placeholder.
#' @param rhs A function call using the magrittr semantics.
#' @return The result of calling `rhs(lhs)`.
#' @noRd
NULL

#' EICAT category to numeric
#'
#' @description
#' Convert EICAT categories to numerical values
#'
#' @param cat The EICAT impact category. (e.g., "MC")
#' @param trans Numeric: `1`, `2` or `3`. The method of transformation to
#' convert the EICAT categories `c("MC", "MN", "MO", "MR", "MV")` to numerical
#' values:
#'   - `1`: converts the categories to `c(0, 1, 2, 3, 4)`
#'   - `2`: converts the categories to to `c(1, 2, 3, 4, 5)`
#'   - `3`: converts the categories to to `c(1, 10, 100, 1000, 10000)`
#'
#' @return Numerical values corresponding to the EICAT  base on a transformation
#' @noRd

cat_num <- function(cat, trans) {
  name <- c("MC", "MN", "MO", "MR", "MV")
  if (trans == 1) {
    x <- 0:4
  } else if (trans == 2) {
    x <- 1:5
  } else { # else if trans = 3
    x <- c(0, 1, 10, 100, 1000, 10000)
  }
  names(x) <- name

  return(x[cat])
}
