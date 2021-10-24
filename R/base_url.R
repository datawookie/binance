# Alternative API clusters:
#
# api1.binance.com
# api2.binance.com
# api3.binance.com
#
BASE_URL <- "https://api.binance.com"
#
# Base URL for testing: https://testnet.binance.vision/.

base_url <- function(url = NULL) {
  if (!is.null(url)) {
    BASE_URL <<- url
  }

  BASE_URL
}
