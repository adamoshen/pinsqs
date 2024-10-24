#' Read and write `.qs` objects to and from a board
#'
#' Use `pin_qsave()` to pin a `.qs` object, and use `pin_qread()` to retrieve it.
#'
#' @param board A pin board, created by a `pins::board_*()` function.
#' @param name Pin name.
#' @param nthreads Number of threads to use. Defaults to value returned by [parallel::detectCores()]
#' divided by 2. If `parallel::detectCores()` returns `NA`, this will fallback to the default of 1.
#' @param ... Additional arguments passed on to [pins::pin_upload()]/[pins::pin_download()], or
#' methods for a specific board. This includes additional fields such as `title` and `description`.
#' @examples
#' library(tibble)
#' library(magrittr)
#' library(pins)
#'
#' # Initialise the pin board, as usual
#' board <- board_temp()
#'
#' # Create data to be pinned
#' rock <- datasets::rock %>%
#'   as_tibble()
#'
#' # Pin the data to the board (as a `.qs` file)
#' board %>%
#'   pin_qsave(
#'     rock, "rock-tibble",
#'     description="`rock` data set as a tibble"
#'   )
#'
#' # Checking the contents of our pin board, as usual
#' board %>%
#'   pin_search()
#'
#' # View pin metadata, as usual
#' board %>%
#'   pin_meta("rock-tibble")
#'
#' # Read the pinned data (as a `.qs` file) from the board
#' board %>%
#'   pin_qread("rock-tibble")
#' @rdname read-write
#' @export
pin_qread <- function(board, name, nthreads=NULL, ...) {
  nthreads <- nthreads %||% get_nthreads()

  x <- pins::pin_download(board, name, ...)
  qs::qread(x, nthreads=nthreads)
}

#' @param x An object to pin.
#' @rdname read-write
#' @export
pin_qsave <- function(board, x, name, nthreads=NULL, ...) {
  nthreads <- nthreads %||% get_nthreads()

  path <- fs::path_temp(fs::path_ext_set(name, "qs"))
  withr::defer(fs::file_delete(path))

  qs::qsave(x, path, nthreads=nthreads)
  pins::pin_upload(board, path, name, ...)
}
