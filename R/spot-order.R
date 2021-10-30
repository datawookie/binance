#' Create new order
#'
#' Exposes the \code{POST /api/v3/order/test} endpoint.
#'
#' @name spot-new-order
#' @inheritParams trade-parameters
#' @param side Trade side. Either \code{"BUY"} or \code{"SELL"}.
#' @param quantity Amount to buy or sell.
#' @param price Price at which to buy or sell.
#' @param time_in_force Time for which order is valid. Options are: \code{"GTC"}
#'   — (Good Til Canceled) order will remain on the book unless canceled;
#'   \code{"IOC"} —	(Immediate Or Cancel) try to fill as much as possible before
#'   it expires; or \code{"FOK"} — (Fill Or Kill) Order will expire if full
#'  order cannot be filled.
#' @param test Is this just a test?
#' @param fills Whether to returns \code{fills} element.
#' @param ... Further arguments passed to or from other methods.
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' spot_new_order()
#' }
spot_new_order <- function(
  order_type,
  symbol,
  side,
  quantity,
  price = NULL,
  time_in_force = NULL,
  test = FALSE,
  fills = TRUE
) {
  check_spot_order_type(order_type)
  check_spot_order_side(side)
  check_time_in_force(time_in_force)

  if (order_type %in% c("LIMIT", "STOP_LOSS_LIMIT", "TAKE_PROFIT_LIMIT", "LIMIT_MAKER") && is.null(price)) {
    stop("Must specify price.")
  }

  endpoint <- "/api/v3/order"
  if (test) {
    endpoint <- paste0(endpoint, "/test")
  }

  order <- POST(
    endpoint,
    query = list(
      symbol = symbol,
      side = side,
      quantity = quantity,
      price = price,
      type = order_type,
      timeInForce = time_in_force
    ),
    simplifyVector = FALSE,
    security_type = "USER_DATA"
  )

  order$fills <- order$fills %>% bind_rows() %>% list()

  order %>%
    as_tibble() %>%
    clean_names() %>%
    select(-order_list_id, -client_order_id, -cummulative_quote_qty) %>%
    when(
      !fills ~ select(., -fills),
      ~ identity(.)
    ) %>%
    fix_types() %>%
    fix_columns()
}

#' @rdname spot-new-order
#' @export
spot_new_market_order <- function(...) {
  spot_new_order("MARKET", ...)
}

#' @rdname spot-new-order
#' @export
spot_new_limit_order <- function(...) {
  arguments <- list(...)

  arguments$order_type <- "LIMIT"

  if (!("time_in_force") %in% names(arguments)) arguments$time_in_force <- "GTC"

  do.call(spot_new_order, arguments)
}

#' Get open orders
#'
#' Exposes the \code{GET /api/v3/openOrders} endpoint.
#'
#' @inheritParams trade-parameters
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' spot_open_orders()
#' spot_open_orders("ETHUSDT")
#' }
spot_open_orders <- function(symbol = NULL) {
  orders <- GET(
    "/api/v3/openOrders",
    query = list(
      symbol = convert_symbol(symbol)
    ),
    simplifyVector = FALSE,
    security_type = "USER_DATA"
  )

  if (length(orders)) {
    orders %>%
      bind_rows() %>%
      clean_names() %>%
      select(-order_list_id, -client_order_id, -cummulative_quote_qty) %>%
      fix_types()
  } else {
    NULL
  }
}
