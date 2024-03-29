#' Deposit history
#'
#' Exposes the \code{GET /sapi/v1/capital/deposit/hisrec} endpoint.
#'
#' @inheritParams trade-parameters
#' @inheritParams limit-1000-1000
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' wallet_deposit_history("ETH")
#' }
wallet_deposit_history <- function(
  coin,
  start_time = NULL,
  end_time = NULL,
  limit = 1000
) {
  coin <- validate_coin(coin)

  history <- GET(
    "/sapi/v1/capital/deposit/hisrec",
    simplifyVector = FALSE,
    security_type = "USER_DATA",
    query = list(
      coin = coin,
      startTime = time_to_timestamp(start_time),
      endTime = time_to_timestamp(end_time),
      limit = limit
    )
  )

  history <- history %>%
    bind_rows() %>%
    clean_names() %>%
    fix_types()

  # The address_tag column doesn't seem to be present on testnet.
  #
  try(history <- history %>% select(-address_tag), silent = TRUE)

  history
}

#' Deposit address
#'
#' Exposes the \code{GET /sapi/v1/capital/deposit/address} endpoint.
#'
#' @inheritParams trade-parameters
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' wallet_deposit_address("ETH")
#' wallet_deposit_address("BNB", network = "BSC")
#' }
wallet_deposit_address <- function(
  coin,
  network = NULL
) {
  coin <- validate_coin(coin)

  GET(
    "/sapi/v1/capital/deposit/address",
    simplifyVector = FALSE,
    security_type = "USER_DATA",
    query = list(
      coin = coin,
      network = network
    )
  ) %>%
    as_tibble() %>%
    select(-tag)
}

#' Withdrawal history
#'
#' Exposes the \code{GET /sapi/v1/capital/withdraw/history} endpoint.
#'
#' @inheritParams trade-parameters
#' @inheritParams limit-1000-1000
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' wallet_withdrawal_history("ETH")
#' }
wallet_withdrawal_history <- function(
  coin,
  start_time = NULL,
  end_time = NULL,
  limit = 1000
) {
  GET(
    "/sapi/v1/capital/withdraw/history",
    simplifyVector = FALSE,
    security_type = "USER_DATA",
    query = list(
      coin = coin,
      startTime = time_to_timestamp(start_time),
      endTime = time_to_timestamp(end_time),
      limit = limit
    )
  ) %>%
    bind_rows() %>%
    clean_names() %>%
    fix_types()
}
