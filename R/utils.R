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
