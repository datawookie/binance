#' Transferred assets among funding account and other accounts
#'
#' Exposes the \code{GET /sapi/v1/asset/transfer} endpoint.
#'
#' @inheritParams trade-parameters
#' @inheritParams transfer-parameters
#' @inheritParams limit-5-30
#' @param ... Further arguments passed to or from other methods.
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' wallet_asset_transfer(type = "FUNDING_MAIN")
#' }
wallet_asset_transfer <- function(
  type = "MAIN_FUNDING",
  start_time = NULL,
  end_time = NULL,
  limit = 5,
  ...
) {
  if (!(type %in% TRANSFER_TYPES)) {
    stop("Invalid transfer type. Options are ", paste(TRANSFER_TYPES, collapse = ", "), ".", sep = "")
  }
  GET(
    "/sapi/v1/asset/transfer",
    simplifyVector = FALSE,
    security_type = "USER_DATA",
    query = list(
      type = type,
      startTime = time_to_timestamp(start_time),
      endTime = time_to_timestamp(end_time),
      limit = limit,
      ...
    )
  )[[1]]
}
