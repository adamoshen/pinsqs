# Read and write `.qs` objects to and from a board

Use `pin_qwrite()` to pin a `.qs` object, and use `pin_qread()` to
retrieve it.

## Usage

``` r
pin_qread(board, name, nthreads = NULL, ...)

pin_qwrite(board, x, name, nthreads = NULL, ...)
```

## Arguments

- board:

  A pin board, created by a `pins::board_*()` function.

- name:

  Pin name.

- nthreads:

  Number of threads to use. Defaults to value returned by
  [`parallel::detectCores()`](https://rdrr.io/r/parallel/detectCores.html)
  divided by 2. If
  [`parallel::detectCores()`](https://rdrr.io/r/parallel/detectCores.html)
  returns `NA`, this will fallback to the default of 1.

- ...:

  Additional arguments passed on to
  [`pins::pin_upload()`](https://pins.rstudio.com/reference/pin_download.html)/[`pins::pin_download()`](https://pins.rstudio.com/reference/pin_download.html),
  or methods for a specific board. This includes additional fields such
  as `title` and `description`.

- x:

  An object to pin.

## Details

Note:
[`pin_qsave()`](https://adamoshen.github.io/pinsqs/reference/deprecated.md)
has been deprecated in favour of `pin_qwrite()`.

## Examples

``` r
library(tibble)
library(magrittr)
library(pins)

# Initialise the pin board, as usual
board <- board_temp()

# Create data to be pinned
rock <- datasets::rock %>%
  as_tibble()

# Pin the data to the board (as a `.qs` file)
board %>%
  pin_qwrite(
    rock, "rock-tibble",
    description = "`rock` data set as a tibble"
  )
#> Creating new version '20260312T010826Z-d8ed3'

# Checking the contents of our pin board, as usual
board %>%
  pin_search()
#> # A tibble: 1 × 6
#>   name        type  title               created             file_size meta      
#>   <chr>       <chr> <chr>               <dttm>              <fs::byt> <list>    
#> 1 rock-tibble file  rock-tibble: a pin… 2026-03-11 21:08:26     1.01K <pins_met>

# View pin metadata, as usual
board %>%
  pin_meta("rock-tibble")
#> List of 13
#>  $ file       : chr "rock-tibble.qs"
#>  $ file_size  : 'fs_bytes' int 1.01K
#>  $ pin_hash   : chr "d8ed3112a49e9960"
#>  $ type       : chr "file"
#>  $ title      : chr "rock-tibble: a pinned .qs file"
#>  $ description: chr "`rock` data set as a tibble"
#>  $ tags       : NULL
#>  $ urls       : NULL
#>  $ created    : POSIXct[1:1], format: "2026-03-11 21:08:26"
#>  $ api_version: int 1
#>  $ user       : list()
#>  $ name       : chr "rock-tibble"
#>  $ local      :List of 3
#>   ..$ dir    : 'fs_path' chr "C:/Users/Adam/AppData/Local/Temp/RtmpyicWjs/pins-19201ee6bab/rock-tibble/20260312T010826Z-d8ed3"
#>   ..$ url    : NULL
#>   ..$ version: chr "20260312T010826Z-d8ed3"

# Read the pinned data (as a `.qs` file) from the board
board %>%
  pin_qread("rock-tibble")
#> # A tibble: 48 × 4
#>     area  peri  shape  perm
#>    <int> <dbl>  <dbl> <dbl>
#>  1  4990 2792. 0.0903   6.3
#>  2  7002 3893. 0.149    6.3
#>  3  7558 3931. 0.183    6.3
#>  4  7352 3869. 0.117    6.3
#>  5  7943 3949. 0.122   17.1
#>  6  7979 4010. 0.167   17.1
#>  7  9333 4346. 0.190   17.1
#>  8  8209 4345. 0.164   17.1
#>  9  8393 3682. 0.204  119  
#> 10  6425 3099. 0.162  119  
#> # ℹ 38 more rows
```
