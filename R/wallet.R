#' Get information of coins (available for deposit and withdraw) for user.
#'
#' Exposes the \code{GET /sapi/v1/capital/config/getall} endpoint.
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' wallet_coins()
#' }
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

#' Daily account snapshot
#'
#' Exposes the \code{GET /sapi/v1/accountSnapshot} endpoint.
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' wallet_daily_snapshot()
#' }
wallet_daily_snapshot <- function(type = "SPOT") {
  if (!(type %in% ORDER_TYPES)) {
    stop("Invalid order type. Options are ", paste(ORDER_TYPES, collapse = ", "), ".", sep = "")
  }

  binance:::GET(
    "/sapi/v1/accountSnapshot",
    simplifyVector = FALSE,
    security_type = "USER_DATA",
    query = list(
      type = type
    )
  )$snapshotVos %>%
    lapply(function(x) {x$data = list(x$data); x}) %>%
    bind_rows() %>%
    unnest_wider(data) %>%
    clean_names() %>%
    mutate(
      update_time = convert_time(update_time),
      update_time = floor_date(update_time, unit = "days")
    ) %>%
    rename(time = update_time)
}
