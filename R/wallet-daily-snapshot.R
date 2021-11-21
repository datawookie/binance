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
  check_order_type(type)

  snapshot <- GET(
    "/sapi/v1/accountSnapshot",
    simplifyVector = FALSE,
    security_type = "USER_DATA",
    query = list(
      type = type,
      startTime = time_to_timestamp(start_time),
      endTime = time_to_timestamp(end_time),
      limit = limit
    )
  )$snapshotVos

  if (length(snapshot) > 0) {
    snapshot %>%
      purrr::map_dfr(~ {.x$data = list(.x$data); .x}) %>%
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
  } else {
    log_debug("No accounts found.")
    NULL
  }
}
