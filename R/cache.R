cache <- new.env()

cache_get <- function(x) {
  if (log_threshold() >= DEBUG) {
    log_debug("Cache contents:")
    for (key in ls(cache)) {
      log_debug("- {key} -> {get(key, envir = cache)} {ifelse(x == key, '*', '')}")
    }
  }
  possibly(get, NULL)(x, envir = cache)
}

cache_set <- function(x, value) {
  assign(x, value, envir = cache)
}

.onLoad <- function(libname, pkgname) {
  # Alternative API clusters:
  #
  # api1.binance.com
  # api2.binance.com
  # api3.binance.com
  #
  # Base URL for testing: https://testnet.binance.vision/.
  #
  cache$BASE_URL <- "https://api.binance.com"
}
