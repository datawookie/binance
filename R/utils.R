parse_time <- function(time, tz = "UTC") {
  if (is.numeric(time)) {
    time <- as.POSIXct(as.numeric(time) / 1000, origin = "1970-01-01")
  } else {
    time <- as.POSIXct(time, tz = tz)
  }

  if (!is.na(tz)) {
    with_tz(time, tz)
  } else {
    time
  }
}

convert_symbol <- function(symbol) {
  sub("/", "", symbol)
}

time_to_timestamp <- function(time = NA, tz = "UTC") {
  if (is.null(time)) {
    NULL
  } else {
    if (is.na(time)) time <- Sys.time()
    if (is.character(time)) time <- as.POSIXct(time, tz = tz)

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

fix_types <- function(.data) {
  .data %>%
    mutate_at(vars(ends_with("time")), parse_time) %>%
    mutate_at(vars(matches(c("amount", "fee", "qty", "price"))), as.numeric)
}
