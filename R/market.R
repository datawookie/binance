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

#' Get the current server time
#'
#' Exposes the \code{GET /api/v3/time} endpoint.
#'
#' @return A \code{POSIXct} object.
#' @export
#'
#' @examples
#' market_server_time()
market_server_time <- function() {
  GET("/api/v3/time") %>% convert_time()
}

#' Current exchange trading rules and symbol information
#'
#' Exposes the \code{GET /api/v3/exchangeInfo} endpoint.
#'
#' @return A \code{POSIXct} object.
#' @export
#'
#' @examples
#' market_exchange_info()
market_exchange_info <- function() {
  info <- binance:::GET("/api/v3/exchangeInfo")

  info$symbols <- lapply(info$symbols, function(symbol) {
    symbol$permissions <- list(unlist(symbol$permissions))
    symbol$orderTypes <- list(unlist(symbol$orderTypes))
    symbol$filters <- list(bind_rows(symbol$filters))
    symbol
  }) %>%
    bind_rows() %>%
    clean_names()

  info$rateLimits <- info$rateLimits %>% bind_rows() %>% clean_names()

  info$serverTime <- convert_time(info$serverTime)

  names(info) <- make_clean_names(names(info))

  info
}

#' K-Lines (candlestick bars) for a symbol
#'
#' Exposes the \code{GET /api/v3/klines} endpoint.
#'
#' @inheritParams trade-parameters
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
  symbol <- convert_symbol(symbol)
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
  GET(
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

#' Latest price for a symbol
#'
#' Exposes the \code{GET /api/v3/ticker/price} endpoint.
#'
#' @inheritParams trade-parameters
#'
#' @return
#' @export
#'
#' @examples
#' market_recent_trades("BTCUSDT")
market_price_ticker <- function(symbol) {
  symbol <- convert_symbol(symbol)
  GET(
    "/api/v3/ticker/price",
    query = list(
      symbol = symbol
    ),
    simplifyVector = TRUE
  )
    # as_tibble() %>%
    # mutate(
    #   symbol = symbol,
    #   time = convert_time(time)
    # ) %>%
    # select(symbol, everything()) %>%
    # clean_names()
}
