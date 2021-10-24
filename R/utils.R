convert_time <- function(time) {
  as.POSIXct(as.numeric(time) / 1000, origin = "1970-01-01")
}

timestamp <- function() {
  sprintf("%.0f", as.numeric(Sys.time()) * 1000)
}

signature <- function(query = NA, body = NA, key = NA) {
  if (is.na(query)) {
    query <- NULL
  } else {
    if (is.list(query)) {
    query <- httr:::compose_query(httr:::compact(query))
    }
  }
  if (is.na(body)) {
    body <- NULL
  } else {
    if (is.list(body)) {
      body <- httr:::compose_query(httr:::compact(body))
    }
  }

  if (is.na(key)) key <- cache_get(API_SECRET)

  object <- paste(query, body, sep = "")
  log_debug("sign: {object}")

  hmac(
    object = object,
    key = key,
    algo = "sha256",
    serialize = FALSE
  )
}
