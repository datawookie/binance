#' @import logger
#' @import dplyr
#' @import httr
#' @importFrom janitor make_clean_names clean_names
#' @importFrom digest hmac
#' @importFrom jsonlite fromJSON
#' @importFrom purrr when possibly
NULL

USER_AGENT <- user_agent("https://github.com/datawookie/binance")

#' Parameters for trade functions
#'
#' @name trade-parameters
#'
#' @param symbol Symbol.
NULL
