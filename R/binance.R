#' @import logger
#' @import dplyr
#' @import httr
#' @importFrom digest hmac
#' @importFrom jsonlite fromJSON
#' @importFrom purrr when
NULL

USER_AGENT <- user_agent("https://github.com/datawookie/binance")
