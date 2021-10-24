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
#' klines("BTCUSDT")
klines <- function(symbol, interval = "1m", limit = 500, volume = FALSE) {
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
