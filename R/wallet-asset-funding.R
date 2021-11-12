#' Get Funding Wallet
#'
#' @inheritParams trade-parameters
#'
#' @return
#' @export
#'
#' @examples
#' wallet_get_funding_asset("USDT")
wallet_get_funding_asset <- function(coin = NULL) {
  query <- if (is.null(coin)) list() else list(asset = validate_coin(coin))

  POST(
    "/sapi/v1/asset/get-funding-asset",
    query = query,
    simplifyVector = FALSE,
    security_type = "USER_DATA"
  ) %>%
    bind_rows() %>%
    clean_names() %>%
    mutate_at(vars(-asset), as.numeric)
}
