#' Get current account information
#'
#' Exposes the \code{GET /api/v3/account} endpoint.
#'
#' @name spot-account
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' spot_account()
#' # Just retrieve balances.
#' spot_account_balances()
#' }
spot_account <- function() {
  account <- GET(
    "/api/v3/account",
    simplifyVector = FALSE,
    security_type = "USER_DATA"
  )

  names(account) <- make_clean_names(names(account))

  account$commission <- account[
    c(
      "maker_commission",
      "taker_commission",
      "buyer_commission",
      "seller_commission"
    )
  ] %>%
    as_tibble() %>%
    rename_with(~ tolower(sub("_commission", "", .x)))

  account$maker_commission <- NULL
  account$taker_commission <- NULL
  account$buyer_commission <- NULL
  account$seller_commission <- NULL

  account$balances <- account$balances %>%
    bind_rows() %>%
    mutate_at(c("free", "locked"), as.numeric) %>%
    filter(free > 0 | locked > 0)

  account$update_time <- parse_time(account$update_time)

  account$permissions <- unlist(account$permissions)

  account
}

#' @rdname spot-account
#' @export
spot_account_balances <- function() {
  spot_account()$balances
}

#' Get current account trades list
#'
#' Exposes the \code{GET /api/v3/myTrades} endpoint.
#'
#' @inheritParams trade-parameters
#' @inheritParams limit-500-1000
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' spot_trades_list("ENJ/ETH")
#' spot_trades_list("ENJ/ETH", start_time = "2021-09-08", end_time = "2021-09-09")
#' }
spot_trades_list <- function(
  symbol,
  start_time = NULL,
  end_time = NULL,
  limit = 500
) {
  log_debug("Retrieving trades on {symbol}.")
  trades <- GET(
    "/api/v3/myTrades",
    query = list(
      symbol = convert_symbol(symbol),
      startTime = time_to_timestamp(start_time),
      endTime = time_to_timestamp(end_time),
      limit = limit
    ),
    security_type = "USER_DATA"
  ) %>%
    bind_rows() %>%
    clean_names()

  if (nrow(trades)) {
    trades %>%
      mutate(
        time = parse_time(time),
        side = ifelse(is_buyer, "BUY", "SELL")
        ) %>%
      mutate_at(c("price", "qty", "quote_qty", "commission"), as.numeric) %>%
      select(symbol, time, everything(), -order_list_id, -is_buyer)
  } else {
    NULL
  }
}

#' Get current account trades list
#'
#' Exposes the \code{GET /api/v3/openOrders} endpoint.
#'
#' @inheritParams trade-parameters
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' spot_open_orders("ENJ/ETH")
#' }
spot_open_orders <- function(symbol) {
  log_debug("Retrieving open orders on {symbol}.")
  orders <- GET(
    "/api/v3/openOrders",
    query = list(
      symbol = convert_symbol(symbol)
    ),
    security_type = "USER_DATA"
  ) %>%
    bind_rows() %>%
    clean_names()

  if (nrow(orders)) {
    orders %>%
      mutate_at(vars(ends_with("time")), parse_time) %>%
      mutate_at(vars(ends_with("qty"), ends_with("price")), as.numeric) %>%
      select(symbol, time, everything(), -order_list_id, -client_order_id)
  } else {
    NULL
  }
}
