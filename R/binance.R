#' @import logger
#' @import dplyr
#' @import httr
#' @importFrom curl curl_escape
#' @importFrom janitor make_clean_names clean_names
#' @importFrom digest hmac
#' @importFrom jsonlite fromJSON
#' @importFrom purrr when possibly map map_dfr
#' @importFrom stats setNames time
#' @importFrom lubridate with_tz
#' @importFrom tidyr unnest_wider
#' @importFrom utils data
NULL

USER_AGENT <- user_agent("https://github.com/datawookie/binance")

ORDER_TYPES = c("SPOT", "MARGIN", "FUTURES")

TRANSFER_TYPES = c("MAIN_FUNDING", "FUNDING_MAIN", "FUNDING_UMFUTURE", "UMFUTURE_FUNDING",
                   "MARGIN_FUNDING", "FUNDING_MARGIN", "FUNDING_CMFUTURE", "CMFUTURE_FUNDING")

SPOT_ORDER_TYPES = c("LIMIT", "MARKET", "STOP_LOSS", "STOP_LOSS_LIMIT", "TAKE_PROFIT", "TAKE_PROFIT_LIMIT", "LIMIT_MAKER")
SPOT_ORDER_SIDES = c("BUY", "SELL")

TIME_IN_FORCE = c("GTC", "IOC", "FOK")

#' Parameters for trade functions
#'
#' @name trade-parameters
#'
#' @param coin Coin.
#' @param symbol Symbol.
#' @param start_time Start time. Something that can be coerced to \code{POSIXct}.
#' @param end_time End time. Something that can be coerced to \code{POSIXct}.
#' @param interval Time interval. One  of 1m, 3m, 5m, 15m, 30m, 1h, 2h, 4h, 6h,
#'   8h, 12h, 1d, 3d, 1w or 1M where m = minutes, h = hours, d = days,
#'   w = weeks and M = months.
#' @param type Order type. One of \code{"SPOT"}, \code{"MARGIN"} or \code{"FUTURES"}.
#' @param order_type Order type. One of \code{"LIMIT"}, \code{"MARKET"},
#'   \code{"STOP_LOSS"}, \code{"STOP_LOSS_LIMIT"}, \code{"TAKE_PROFIT"},
#'   \code{"TAKE_PROFIT_LIMIT"} or \code{"LIMIT_MAKER"}.
#' @param network Blockchain network.
NULL

#' Parameters for transfer functions
#'
#' @name transfer-parameters
#'
#' @param type Transfer type. One of \code{"MAIN_FUNDING"},
#'   \code{"FUNDING_MAIN"}, \code{"FUNDING_UMFUTURE"},
#'   \code{"UMFUTURE_FUNDING"}, \code{"MARGIN_FUNDING"},
#'   \code{"FUNDING_MARGIN"}, \code{"FUNDING_CMFUTURE"} or
#'  \code{"CMFUTURE_FUNDING"}.
NULL

#' Limit with default 500 and maximum 1000.
#'
#' @name limit-500-1000
#'
#' @param limit Maximum number of records in result. Default is 500 and maximum
#'   is 1000.
NULL

#' Limit with default 1000 and maximum 1000.
#'
#' @name limit-1000-1000
#'
#' @param limit Maximum number of records in result. Default is 1000 and maximum
#'   is 1000.
NULL

#' Limit with default 5 and maximum 30.
#'
#' @name limit-5-30
#'
#' @param limit Maximum number of records in result. Default is 5, minimum is 5
#'   and maximum is 30.
NULL

globalVariables(
  c(
    "open_time",
    "close_time",
    "cummulative_quote_qty",
    "ignore",
    "free",
    "locked",
    "order_list_id",
    "coin",
    "address_tag",
    "balances",
    "begins_with",
    "client_order_id",
    "is_buyer",
    "operate_time",
    "tag",
    "trades",
    "update_time"
  )
)
