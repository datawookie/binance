#' Get current account information
#'
#' Exposes the \code{GET /api/v3/account} endpoint.
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' klines("BTCUSDT")
account <- function() {
  account <- binance:::GET(
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

  account$permissions <- unlist(account$permissions)

  account
}
