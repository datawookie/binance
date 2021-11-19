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
  time <- GET("/api/v3/time")$serverTime

  log_debug("Timestamp: ", format_timestamp(time, seconds = FALSE), ".")

  time %>% parse_time()
}

#' Current exchange trading rules and symbol information
#'
#' Exposes the \code{GET /api/v3/exchangeInfo} endpoint.
#'
#' @name market-exchange-info
#' @return A \code{POSIXct} object.
#' @export
#'
#' @examples
#' market_exchange_info()
market_exchange_info <- function() {
  info <- GET("/api/v3/exchangeInfo")

  info$symbols <- lapply(info$symbols, function(symbol) {
    symbol$permissions <- list(unlist(symbol$permissions))
    symbol$orderTypes <- list(unlist(symbol$orderTypes))
    symbol$filters <- list(bind_rows(symbol$filters))
    symbol
  }) %>%
    bind_rows() %>%
    clean_names() %>%
    select_at(vars(-ends_with("precision"))) %>%
    rename_all(~ sub("_asset", "", .x))

  info$rateLimits <- info$rateLimits %>% bind_rows() %>% clean_names()

  info$serverTime <- parse_time(info$serverTime)

  names(info) <- make_clean_names(names(info))

  info
}

#' @rdname market-exchange-info
#' @export
market_exchange_symbols <- function() {
  market_exchange_info()$symbols
}

#' K-Lines (candlestick bars) for a symbol
#'
#' Exposes the \code{GET /api/v3/klines} endpoint.
#'
#' @inheritParams trade-parameters
#' @inheritParams limit-500-1000
#' @param volume Whether to include volume data in output.
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' market_klines("BTCUSDT")
market_klines <- function(
  symbol,
  interval = "1m",
  start_time = NULL,
  end_time = NULL,
  limit = 500,
  volume = FALSE
) {
  log_debug("Retrieving k-lines on {symbol}.")
  symbol <- convert_symbol(symbol)
  klines <- GET(
    "/api/v3/klines",
    query = list(
      symbol = symbol,
      interval = interval,
      startTime = time_to_timestamp(start_time),
      endTime = time_to_timestamp(end_time),
      limit = limit
    ),
    simplifyVector = FALSE
  )

  klines %>%
    map_dfr(function(kline) {
      as.data.frame(kline, col.names = c(
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
      ))
    }) %>%
    as_tibble() %>%
    mutate(
      symbol = symbol,
      trades = as.integer(trades)
      ) %>%
    fix_types() %>%
    mutate_at(vars(open:volume), as.numeric) %>%
    select(symbol, open_time, close_time, everything(), -ignore) %>%
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
#' @return A data frame.
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
      time = parse_time(time)
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
#' @return A data frame.
#' @export
#'
#' @examples
#' market_price_ticker("BTCUSDT")
market_price_ticker <- function(symbol = NULL) {
  symbol <- convert_symbol(symbol)
  GET(
    "/api/v3/ticker/price",
    query = list(
      symbol = symbol
    ),
    simplifyVector = TRUE
  ) %>% as_tibble() %>%
    fix_types()
}


#' Order book
#'
#' Exposes the \code{GET /api/v3/depth} endpoint.
#'
#' @inheritParams trade-parameters
#' @inheritParams limit-100-5000
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' market_order_book("BTCUSDT")
#' market_order_book(c("BTCUSDT", "TRXUSDT"))
market_order_book <- function(symbol, side = NULL, limit = 100) {
  side <- check_order_side(side)

  if (length(symbol) > 1) {
    map_dfr(symbol, market_order_book)
  } else {
    log_debug("Retrieve order book for {symbol}.")
    symbol <- convert_symbol(symbol)
    orders <- GET(
      "/api/v3/depth",
      query = list(
        symbol = symbol,
        limit = limit
      ),
      simplifyVector = TRUE
    )

    fix_matrix <- function(orders) {
      if (length(orders)) {
        orders <- orders %>%
          as_tibble(.name_repair = "minimal") %>%
          setNames(c("price", "qty")) %>%
          mutate_all(as.numeric)
      } else {
        orders <- tibble(price = numeric(), qty = numeric())
      }

      orders %>% list()
    }
    orders$asks <- fix_matrix(orders$asks)
    orders$bids <- fix_matrix(orders$bids)

    orders <- orders %>%
      as_tibble() %>%
      mutate(symbol = symbol) %>%
      clean_names() %>%
      select(symbol, everything())

    if (!is.null(side)) {
      orders <- orders %>% select(-last_update_id)

      if (side == "BUY") {
        orders %>% select(-asks) %>% unnest(cols = bids)
      } else {
        orders %>% select(-bids) %>% unnest(cols = asks)
      }
    } else {
      orders
    }
  }
}
