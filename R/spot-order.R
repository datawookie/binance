#' Create new order
#'
#' Exposes the \code{POST /api/v3/order/} endpoint.
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
#'   order cannot be filled.
#' @param test Is this just a test?
#' @param fills Whether to returns \code{fills} element.
#' @param ... Further arguments passed to or from other methods.
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' # Create new order (returns a data frame).
#' spot_new_order(
#'   order_type = "LIMIT",
#'   symbol = "LTCUSDT",
#'   side = "SELL",
#'   quantity = 1,
#'   price = 67,
#'   time_in_force = "GTC"
#' )
#'
#' # Test new order creation (returns a Boolean).
#' spot_new_order(
#'   order_type = "LIMIT",
#'   symbol = "LTCUSDT",
#'   side = "SELL",
#'   quantity = 1,
#'   price = 67,
#'   time_in_force = "GTC",
#'   test = TRUE
#' )
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
  check_order_side(side)
  check_time_in_force(time_in_force)

  if (order_type %in% c("LIMIT", "STOP_LOSS_LIMIT", "TAKE_PROFIT_LIMIT", "LIMIT_MAKER") && is.null(price)) {
    stop("Must specify price.")
  }

  if (order_type %in% c("MARKET") && !is.null(price)) {
    stop("Don't specify price.")
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

  if (test) {
    # If test successful then the result would be an empty list. If test failed
    # then result would be NULL.
    #
    class(order) == "list"
  } else {
    order$fills <- order$fills %>% bind_rows() %>% fix_types() %>% clean_names() %>% list()

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

#' Query an order
#'
#' Exposes the \code{GET /api/v3/order} endpoint.
#'
#' @inheritParams trade-parameters
#' @param order_id Order ID.
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' spot_order_query("ETHUSDT", 42)
#' }
spot_order_query <- function(symbol, order_id) {
  GET(
    "/api/v3/order",
    query = list(
      symbol = convert_symbol(symbol),
      orderId = order_id
    ),
    simplifyVector = FALSE,
    security_type = "USER_DATA"
  ) %>%
    as_tibble() %>%
    clean_names() %>%
    select(-order_list_id, -client_order_id, -cummulative_quote_qty) %>%
    fix_types()
}

#' Cancel an order
#'
#' Exposes the \code{DELETE /api/v3/order} endpoint.
#'
#' @inheritParams trade-parameters
#' @param order_id Order ID.
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' spot_order_cancel("ETHUSDT", 42)
#' }
spot_order_cancel <- function(symbol, order_id) {
  DELETE(
    "/api/v3/order",
    query = list(
      symbol = convert_symbol(symbol),
      orderId = order_id
    ),
    simplifyVector = FALSE,
    security_type = "USER_DATA"
  ) %>%
    as_tibble() %>%
    clean_names() %>%
    select(-order_list_id, -client_order_id, -orig_client_order_id, -cummulative_quote_qty) %>%
    fix_types()
}
