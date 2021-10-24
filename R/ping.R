#' Test connectivity to the Binance REST API
#'
#' @return \code{TRUE} on success or \code{FALSE} on failure.
#' @export
#'
#' @examples
#' ping()
ping <- function() {
  class(try(binance:::GET("/api/v3/ping"), silent = TRUE)) == "list"
}
