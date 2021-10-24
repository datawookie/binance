cache <- new.env()

cache_get <- function(x) {
  possibly(get, NULL)(x, envir = cache)
}

cache_set <- function(x, value) {
  assign(x, value, envir = cache)
}
