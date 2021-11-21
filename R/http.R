TIMEOUT_SECONDS = 30

HEADERS_DEFAULT = list(
  "Content-Type" = 'application/json'
)

check_response <- function(response) {
  if (is.null(content(response))) {
    warning("API returned an empty result.")
    FALSE
  } else if (http_type(response) != "application/json") {
    log_debug(content(response, as = "text"))
    stop("API did not return JSON.", call. = FALSE)
  } else if (status_code(response) != 200) {
    stop(
      sprintf(
        "Binance API request failed [%s] %s",
        status_code(response),
        content(response)$msg
      ),
      call. = FALSE
    )
  } else {
    TRUE
  }
}

#' Set or query API base URL
#'
#' @param url Base URL.
#'
#' @return URL string.
#' @export
#'
#' @examples
#' base_url("https://testnet.binance.vision/")
base_url <- function(url = NULL) {
  if (!is.null(url)) {
    cache$BASE_URL <- url
  } else {
    cache$BASE_URL
  }
}

#' GET
#'
#' The security type can be one of the following:
#'
#' \code{NONE}        Endpoint can be accessed freely.
#' \code{TRADE}       Endpoint requires sending a valid API-Key and signature.
#' \code{USER_DATA}   Endpoint requires sending a valid API-Key and signature.
#' \code{USER_STREAM} Endpoint requires sending a valid API-Key.
#' \code{MARKET_DATA} Endpoint requires sending a valid API-Key.
#'
#' @noRd
GET <- function(
  path,
  query = list(),
  simplifyVector = FALSE,
  security_type = "NONE",
  base_url = NA
) {
  if (is.na(base_url)) base_url <- cache$BASE_URL

  url <- modify_url(base_url, path = path)
  log_debug("GET {url}.")

  signed <- security_type %in% c("USER_DATA", "TRADE")

  headers <- HEADERS_DEFAULT
  #
  if (security_type %in% c("USER_DATA")) {
    binance_api_key <- cache_get(API_KEY)
    if (is.null(binance_api_key)) {
      stop("Call authenticate() first to set API key.", call. = FALSE)
    }
    headers["X-MBX-APIKEY"] = binance_api_key
  }
  #
  if (length(headers)) {
    headers <- do.call(add_headers, headers)
  } else {
    headers <- NULL
  }

  if (signed) {
    query["timestamp"] <- time_to_timestamp()
    query["signature"] <- signature(query)
  }

  # Drop NULL components in query.
  #
  query <- query[!sapply(query, is.null)]

  response <- purrr::insistently(httr::GET)(
    url,
    query = query,
    headers,
    USER_AGENT,
    timeout(TIMEOUT_SECONDS)
  )

  if (check_response(response)) {
    fromJSON(
      content(response, as = "text"),
      simplifyVector = simplifyVector
    )
  } else {
    NULL
  }
}

#' POST
#'
#' @noRd
POST <- function(
  path,
  query = list(),
  body = NULL,
  simplifyVector = FALSE,
  security_type = "NONE",
  base_url = NA
) {
  if (is.na(base_url)) base_url <- cache$BASE_URL

  url <- modify_url(base_url, path = path)
  log_debug("POST {url}.")

  signed <- security_type %in% c("USER_DATA", "TRADE")

  headers <- HEADERS_DEFAULT
  #
  if (security_type %in% c("USER_DATA")) {
    binance_api_key <- cache_get(API_KEY)
    if (is.null(binance_api_key)) {
      stop("Call authenticate() first to set API key.", call. = FALSE)
    }
    headers["X-MBX-APIKEY"] = binance_api_key
  }
  #
  if (length(headers)) {
    headers <- do.call(add_headers, headers)
  } else {
    headers <- NULL
  }

  if (signed) {
    query["timestamp"] <- time_to_timestamp()
    query["signature"] <- signature(query)
  }

  # Drop NULL components in query.
  #
  query <- query[!sapply(query, is.null)]

  response <- httr::POST(
    url,
    query = query,
    body = body,
    headers,
    USER_AGENT,
    timeout(TIMEOUT_SECONDS)
  )

  if (check_response(response)) {
    fromJSON(
      content(response, as = "text"),
      simplifyVector = simplifyVector
    )
  } else {
    NULL
  }
}

#' DELETE
#'
#' @noRd
DELETE <- function(
  path,
  query = list(),
  simplifyVector = FALSE,
  security_type = "NONE"
) {
  url <- modify_url(cache$BASE_URL, path = path)
  log_debug("DELETE {url}.")

  signed <- security_type %in% c("USER_DATA", "TRADE")

  headers <- list()
  #
  if (security_type %in% c("USER_DATA")) {
    binance_api_key <- cache_get(API_KEY)
    if (is.null(binance_api_key)) {
      stop("Call authenticate() first to set API key.", call. = FALSE)
    }
    headers["X-MBX-APIKEY"] = binance_api_key
  }
  #
  if (length(headers)) {
    headers <- do.call(add_headers, headers)
  } else {
    headers <- NULL
  }

  if (signed) {
    query["timestamp"] <- time_to_timestamp()
    query["signature"] <- signature(query)
  }

  # Drop NULL components in query.
  #
  query <- query[!sapply(query, is.null)]

  response <- httr::DELETE(
    url,
    query = query,
    headers,
    USER_AGENT,
    timeout(TIMEOUT_SECONDS)
  )

  if (check_response(response)) {
    fromJSON(
      content(response, as = "text"),
      simplifyVector = simplifyVector
    )
  } else {
    NULL
  }
}

#' Borrowed from httr:::compact.
#' @noRd
compact <- function (x)
{
  empty <- vapply(x, is_empty, logical(1))
  x[!empty]
}

#' Borrowed from httr:::compose_query.
#' @noRd
compose_query <- function (elements)
{
  if (length(elements) == 0) {
    return("")
  }
  if (!all(has_name(elements))) {
    stop("All components of query must be named", call. = FALSE)
  }
  stopifnot(is.list(elements))
  elements <- compact(elements)
  names <- curl::curl_escape(names(elements))
  encode <- function(x) {
    if (inherits(x, "AsIs"))
      return(x)
    curl::curl_escape(x)
  }
  values <- vapply(elements, encode, character(1))
  paste0(names, "=", values, collapse = "&")
}

#' Borrowed from httr:::is_empty.
#' @noRd
is_empty <- function (x) {
  length(x) == 0
}

#' Borrowed from httr:::has_name.
#' @noRd
has_name <- function(x) {
  nms <- names(x)
  if (is.null(nms)) {
    return(rep(FALSE, length(x)))
  }
  !is.na(nms) & nms != ""
}
