#' Test new order
#'
#' Exposes the \code{POST /api/v3/order/test} endpoint.
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' spot_new_order()
#' }
spot_new_order <- function(
  symbol,
  side,
  quantity,
  price = NULL,
  type = "MARKET",
  time_in_force = NULL,
  test = FALSE
) {
  check_spot_order_type(type)
  check_spot_order_side(side)
  check_time_in_force(time_in_force)

  if (type %in% c("LIMIT", "STOP_LOSS_LIMIT", "TAKE_PROFIT_LIMIT", "LIMIT_MAKER") && is.null(price)) {
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
      type = type,
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
    fix_types()
}

#' Get open orders
#'
#' Exposes the \code{GET /api/v3/openOrders} endpoint.
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' spot_open_orders()
#' }
spot_open_orders <- function(symbol) {
  binance:::GET(
    "/api/v3/openOrders",
    query = list(
      symbol = symbol
    ),
    simplifyVector = FALSE,
    security_type = "USER_DATA"
  ) %>%
    bind_rows() %>%
    clean_names() %>%
    select(-order_list_id, -client_order_id, -cummulative_quote_qty) %>%
    fix_types()
}
