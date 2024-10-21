#' @noRd
get_nthreads <- function() {
  ifelse(is.na(parallel::detectCores()), 1, parallel::detectCores() / 2)
}
