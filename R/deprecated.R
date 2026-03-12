#' Deprecated functions
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' Use `pin_qwrite()` instead of `pin_qsave()`.
#' @export
#' @keywords internal
#' @name deprecated
pin_qsave <- function(board, x, name, nthreads = NULL, ...) {
  deprecate_warn("0.0.1", "pin_qsave()", "pin_qwrite()")

  nthreads <- nthreads %||% get_nthreads()

  path <- fs::path_temp(fs::path_ext_set(name, "qs"))
  withr::defer(fs::file_delete(path))

  qs::qsave(x, path, nthreads = nthreads)
  pins::pin_upload(board, path, name, ...)
}
