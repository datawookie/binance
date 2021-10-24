API_KEY = "api_key"
API_SECRET = "api_secret"

authenticate <- function(key = NULL, secret = NULL) {
  if (!is.null(key)) cache_set(API_KEY, user_id)
  if (!is.null(secret)) cache_set(API_SECRET, key)

  TRUE
}
