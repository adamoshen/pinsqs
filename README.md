
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pinsqs

**pinsqs** provides convenience functions to incorporate multithreaded
reading and writing of `.qs` files from the
[qs](https://github.com/qsbase/qs) package into the
[pins](https://github.com/rstudio/pins-r/) infrastructure.

Motivated by this [feature
request](https://github.com/rstudio/pins-r/issues/725) that will not be
implemented as I felt it would benefit my own workflows.

## Installation

You can install this package using:

``` r
# install.packages("remotes")
remotes::install_github("adamoshen/pinsqs")
```

## Example usage

``` r
library(tibble)
library(magrittr)
library(pins)
library(pinsqs)
```

Initialise the pin board, as usual:

``` r
board <- board_temp()
```

Create data to be pinned:

``` r
rock <- datasets::rock %>%
  as_tibble()
```

Pin the data to the board (as a `.qs` file):

``` r
board %>%
  pin_qsave(
    rock, "rock-tibble",
    description = "`rock` data set as a tibble"
  )
#> Creating new version '20241021T070931Z-d8ed3'
```

Checking the contents of our pin board, as usual:

``` r
board %>%
  pin_search()
#> # A tibble: 1 x 6
#>   name        type  title               created             file_size meta      
#>   <chr>       <chr> <chr>               <dttm>              <fs::byt> <list>    
#> 1 rock-tibble file  rock-tibble: a pin~ 2024-10-21 03:09:31     1.01K <pins_met>
```

View pin metadata, as usual:

``` r
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
#>  $ created    : POSIXct[1:1], format: "2024-10-21 03:09:31"
#>  $ api_version: int 1
#>  $ user       : list()
#>  $ name       : chr "rock-tibble"
#>  $ local      :List of 3
#>   ..$ dir    : 'fs_path' chr "C:/Users/Adam/AppData/Local/Temp/Rtmpk9qV94/pins-7a282781258b/rock-tibble/20241021T070931Z-d8ed3"
#>   ..$ url    : NULL
#>   ..$ version: chr "20241021T070931Z-d8ed3"
```

Read the pinned data (from a `.qs` file):

``` r
board %>%
  pin_qread("rock-tibble")
#> # A tibble: 48 x 4
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
#> # i 38 more rows
```

## Notes

If a value for `nthreads` is not supplied to `pin_qread()` or
`pin_qsave()`, it will default to `parallel::detectCores() / 2`.
Otherwise, if `parallel::detectCores()` is `NA`, it will fallback to the
default of the [qs](https://github.com/qsbase/qs) package, which is 1.
