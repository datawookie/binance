convert_time <- function(time) {
  as.POSIXct(as.numeric(time) / 1000, origin = "1970-01-01")
}

convert_symbol <- function(symbol) {
  sub("/", "", symbol)
}

timestamp <- function(time = NA) {
  if (is.null(time)) {
    NULL
  } else {
    if (is.na(time)) time <- Sys.time()
    if (is.character(time)) time <- as.POSIXct(time)

    sprintf("%.0f", as.numeric(time) * 1000)
  }
}

signature <- function(query = NA, body = NA, key = NA) {
  if (length(query) == 1 && is.na(query)) {
    query <- NULL
  } else {
    if (is.list(query)) {
      query <- compose_query(compact(query))
    }
  }
  if (length(body) == 1 && is.na(body)) {
    body <- NULL
  } else {
    if (is.list(body)) {
      body <- compose_query(compact(body))
    }
  }

  if (is.na(key)) key <- cache_get(API_SECRET)

  object <- paste(query, body, sep = "")

  hmac(
    object = object,
    key = key,
    algo = "sha256",
    serialize = FALSE
  )
}
