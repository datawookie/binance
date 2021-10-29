#' Test new order
#'
#' Exposes the \code{POST /api/v3/order/test} endpoint.
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' spot_account()
#' }
spot_new_order_test <- function(
  symbol,
  type,
  quantity,
  price
) {
  order <- binance:::POST(
    "/api/v3/order/test",
    query = list(
      symbol = "",
      side = "",
      type = ""
    ),
    simplifyVector = FALSE,
    security_type = "USER_DATA"
  )
}
