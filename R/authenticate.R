API_KEY = "api_key"
API_SECRET = "api_secret"

#' Set Binance REST API key & secret
#'
#' @param key API key.
#' @param secret API secret.
#'
#' @export
#'
#' @examples
#' authenticate(
#'   key = Sys.getenv("BINANCE_API_KEY"),
#'   secret = Sys.getenv("BINANCE_API_SECRET")
#' )
authenticate <- function(key = NULL, secret = NULL) {
  if (!is.null(key)) cache_set(API_KEY, key)
  if (!is.null(secret)) cache_set(API_SECRET, secret)
}
