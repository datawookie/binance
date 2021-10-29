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
#' @inheritParams trade-parameters
#' @inheritParams limit-5-30
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' wallet_daily_snapshot()
#' }
wallet_daily_snapshot <- function(
  type = "SPOT",
  start_time = NULL,
  end_time = NULL,
  limit = 5
) {
  if (!(type %in% ORDER_TYPES)) {
    stop("Invalid order type. Options are ", paste(ORDER_TYPES, collapse = ", "), ".", sep = "")
  }

  GET(
    "/sapi/v1/accountSnapshot",
    simplifyVector = FALSE,
    security_type = "USER_DATA",
    query = list(
      type = type,
      startTime = time_to_timestamp(start_time),
      endTime = time_to_timestamp(end_time),
      limit = limit
    )
  )$snapshotVos %>%
    map_dfr(~ {.x$data = list(.x$data); .x}) %>%
    unnest_wider(data) %>%
    clean_names() %>%
    mutate(
      update_time = parse_time(update_time),
      # update_time = floor_date(update_time, unit = "days"),
      balances = lapply(balances, function(balance) {
        bind_rows(balance) %>%
          mutate(
            free = as.numeric(free),
            locked = as.numeric(locked),
            total = free + locked
          )
      })
    ) %>%
    rename(time = update_time)
}
