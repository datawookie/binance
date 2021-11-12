#' Transferred assets among funding account and other accounts
#'
#' Exposes the \code{GET /sapi/v1/asset/transfer} endpoint.
#'
#' @inheritParams trade-parameters
#' @inheritParams transfer-parameters
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' # Get all transfer types.
#' wallet_asset_transfer()
#' wallet_asset_transfer(type = "MAIN_FUNDING")
#' wallet_asset_transfer(type = "FUNDING_MAIN")
#' }
wallet_asset_transfer <- function(
  type = NULL,
  start_time = NULL,
  end_time = NULL
) {
  if (is.null(type)) {
    log_debug("Retrieving all transfer types.")
    args <- as.list(environment())
    map_dfr(TRANSFER_TYPES, function(type) {
      log_debug("Retrieving transfers: {type}.")
      args$type <- type
      do.call(wallet_asset_transfer, args)
    })
  } else {
    check_transfer_type(type)

    transfers <- binance:::GET(
      "/sapi/v1/asset/transfer",
      simplifyVector = FALSE,
      security_type = "USER_DATA",
      query = list(
        type = type,
        startTime = time_to_timestamp(start_time),
        endTime = time_to_timestamp(end_time)
      )
    )

    if (transfers$total > 0) {
    transfers$rows %>%
      bind_rows() %>%
      clean_names() %>%
      mutate(timestamp = parse_time(timestamp)) %>%
      separate(type, c("from", "to"), remove = FALSE, sep = "_")
    } else {
      NULL
    }
  }
}
