parse_time <- function(time, tz = "UTC") {
  if (is.numeric(time)) {
    time <- as.POSIXct(time / 1000, origin = "1970-01-01")
  } else {
    time <- as.POSIXct(time, tz = tz)
  }

  if (!is.na(tz)) {
    with_tz(time, tz)
  } else {
    time
  }
}

convert_symbol <- function(symbol = NULL) {
  if (is.null(symbol)) {
    NULL
  } else {
    sub("/", "", symbol)
  }
}

format_timestamp <- function(time, seconds = TRUE) {
  time <- as.numeric(time)

  # Is time in seconds or milliseconds?
  if (seconds) time <- time * 1000

  sprintf("%.0f", time)
}

time_to_timestamp <- function(time = NA, tz = "UTC") {
  if (is.null(time)) {
    NULL
  } else {
    if (is.na(time)) {
      time <- Sys.time()
    } else {
      if (is.character(time)) time <- as.POSIXct(time, tz = tz)
    }

    format_timestamp(time)
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
    mutate_at(vars(matches(c("amount", "fee", "qty", "price", "^commission$"))), as.numeric)
}

fix_columns <- function(.data) {
  .data %>%
    rename_with(
      ~ case_when(
        . == "executed_qty" ~ "exec_qty",
        TRUE ~ .
      )
    )
}

validate_coin <- function(coin) {
  coin <- toupper(coin)
  if (coin %in% COINS) {
    coin
  } else {
    stop("Not a valid coin: '", coin, "'.", call. = FALSE)
  }
}

flip_side <- function(side) {
  if (side %in% c("BUY", "SELL")) {
    if (side == "BUY") "SELL" else "BUY"
  } else {
    stop("Invalid side: '", side, "'.")
  }
}

list_null_to_na <- function(.data, recursive = TRUE) {
  .data <- .data %>% modify_if(is.null, function(x) NA)
  if (recursive) {
    .data %>% modify_if(is.list, ~ list_null_to_na(.))
  } else {
    .data
  }
}

make_clean_names_recursive <- function(.data) {
  names(.data) <- make_clean_names(names(.data))

  .data %>% modify_if(is.list, ~ make_clean_names_recursive(.))
}
