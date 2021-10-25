#' Get information of coins (available for deposit and withdraw) for user.
#'
#' Exposes the \code{GET /sapi/v1/capital/config/getall} endpoint.
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' wallet_coins()
wallet_coins <- function() {
  GET(
    "/sapi/v1/capital/config/getall",
    simplifyVector = FALSE,
    security_type = "USER_DATA"
  ) %>%
    lapply(function(coin) {
      coin$network <- list(bind_rows(coin$networkList))
      coin$networkList <- NULL

      coin
    }) %>%
    bind_rows() %>%
    clean_names() %>%
    arrange(coin)
}
