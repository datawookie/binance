#' System status
#'
#' Exposes the \code{GET /sapi/v1/system/status} endpoint.
#'
#' @return A tibble.
#' @export
#'
#' @examples
#' \dontrun{
#' wallet_system_status()
#' }
wallet_system_status <- function() {
  GET(
    "/sapi/v1/system/status",
    simplifyVector = FALSE,
    security_type = "USER_DATA"
  ) %>% as_tibble()
}
