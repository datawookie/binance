check_order_type <- function(type) {
  if (!(type %in% ORDER_TYPES)) {
    stop("Invalid order type. Options are ", paste(ORDER_TYPES, collapse = ", "), ".", sep = "")
  }
}

check_spot_order_type <- function(type) {
  if (!(type %in% SPOT_ORDER_TYPES)) {
    stop("Invalid spot order type. Options are ", paste(SPOT_ORDER_TYPES, collapse = ", "), ".", sep = "")
  }
}

check_order_side <- function(side) {
  if (is.null(side) || is.na(side)) {
    NULL
  } else {
    side <- toupper(side)
    if (!(side %in% SPOT_ORDER_SIDES)) {
      stop("Invalid order side. Options are ", paste(SPOT_ORDER_SIDES, collapse = ", "), ".", sep = "")
    }
    side
  }
}

check_time_in_force <- function(time_in_force) {
  if (!(time_in_force %in% TIME_IN_FORCE) && !is.null(time_in_force)) {
    stop("Invalid time in force. Options are ", paste(TIME_IN_FORCE, collapse = ", "), ".", sep = "")
  }
}
