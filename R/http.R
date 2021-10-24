GET <- function(
  path,
  query = list(),
  simplifyVector = FALSE,
  security_type = "NONE"
) {
  url <- modify_url(BASE_URL, path = path)
  log_debug("GET {url}.")

  signed <- security_type %in% c("USER_DATA", "TRADE")

  headers <- list()
  #
  if (security_type %in% c("USER_DATA")) {
    headers["X-MBX-APIKEY"] = Sys.getenv("BINANCE_API_KEY")
  }
  #
  if (length(headers)) {
    headers <- do.call(add_headers, headers)
  } else {
    headers <- NULL
  }

  if (signed) {
    query["timestamp"] <- timestamp()
    query["signature"] <- signature(query)
  }

  response <- httr::GET(
    url,
    query = query,
    headers,
    USER_AGENT
  )
  if (http_type(response) != "application/json") {
    stop("API did not return JSON.", call. = FALSE)
  }

  parsed <- fromJSON(
    content(response, as = "text"),
    simplifyVector = simplifyVector
  )

  if (status_code(response) != 200) {
    stop(
      sprintf(
        "Binance API request failed [%s] %s",
        status_code(response),
        parsed$msg
      ),
      call. = FALSE
    )
  }

  parsed
}
