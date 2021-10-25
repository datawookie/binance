#' Test connectivity to the Binance REST API
#'
#' @return \code{TRUE} on success or \code{FALSE} on failure.
#' @export
#'
#' @examples
#' market_ping()
market_ping <- function() {
  class(try(GET("/api/v3/ping"), silent = TRUE)) == "list"
}

#' Klines (candlestick bars) for a symbol
#'
#' Exposes the \code{GET /api/v3/klines} endpoint.
#'
#' @inheritParams trade-parameters
#' @param interval Time interval. One  of 1m, 3m, 5m, 15m, 30m, 1h, 2h, 4h, 6h,
#'   8h, 12h, 1d, 3d, 1w or 1M where m = minutes, h = hours, d = days,
#'   w = weeks and M = months.
#' @param limit Maximum number of records in result. Default is 500 and maximum
#'   is 1000.
#' @param volume Whether to include volume data in output.
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' market_klines("BTCUSDT")
market_klines <- function(symbol, interval = "1m", limit = 500, volume = FALSE) {
  GET(
    "/api/v3/klines",
    query = list(
      symbol = symbol,
      interval = interval,
      limit = limit
    ),
    simplifyVector = TRUE
  ) %>%
    as.data.frame() %>%
    setNames(c(
      "open_time",
      "open",
      "high",
      "low",
      "close",
      "volume",
      "close_time",
      "quote_volume",
      "trades",
      "taker_buy_base_volume",
      "taker_buy_quote_volume",
      "ignore"
    )) %>%
    select(open_time, close_time, everything(), -ignore) %>%
    mutate_at(vars(ends_with("_time")), convert_time) %>%
    when(
      !volume ~ select(., -ends_with("_volume")),
      ~ identity(.)
    )
}

#' Current average price for a symbol
#'
#' Exposes the \code{GET /api/v3/avgPrice} endpoint.
#'
#' @inheritParams trade-parameters
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' market_average_price("BTCUSDT")
market_average_price <- function(symbol) {
  symbol <- convert_symbol(symbol)
  GET(
    "/api/v3/avgPrice",
    query = list(
      symbol = symbol
    ),
    simplifyVector = TRUE
  ) %>%
    as_tibble() %>%
    mutate(symbol = symbol) %>%
    select(symbol, everything())
}

#' Get recent trades
#'
#' Exposes the \code{GET /api/v3/trades} endpoint.
#'
#' @inheritParams trade-parameters
#'
#' @return
#' @export
#'
#' @examples
#' market_recent_trades("BTCUSDT")
market_recent_trades <- function(symbol) {
  symbol <- convert_symbol(symbol)
  binance:::GET(
    "/api/v3/trades",
    query = list(
      symbol = symbol
    ),
    simplifyVector = TRUE
  ) %>%
    as_tibble() %>%
    mutate(
      symbol = symbol,
      time = convert_time(time)
    ) %>%
    select(symbol, everything()) %>%
    clean_names()
}
