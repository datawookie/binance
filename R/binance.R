#' @import logger
#' @import dplyr
#' @import httr
#' @importFrom curl curl_escape
#' @importFrom janitor make_clean_names clean_names
#' @importFrom digest hmac
#' @importFrom jsonlite fromJSON
#' @importFrom purrr when possibly
#' @importFrom stats setNames time
NULL

USER_AGENT <- user_agent("https://github.com/datawookie/binance")

#' Parameters for trade functions
#'
#' @name trade-parameters
#'
#' @param symbol Symbol.
#' @param start_time Start time. Something that can be coerced to \code{POSIXct}.
#' @param end_time End time. Something that can be coerced to \code{POSIXct}.
NULL

globalVariables(
  c(
    "open_time",
    "close_time",
    "ignore",
    "free",
    "locked",
    "order_list_id",
    "coin",
    ""
  )
)
