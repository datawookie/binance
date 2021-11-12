#' Transfer dust to BNB
#'
#' Exposes the \code{POST /sapi/v1/asset/dust} endpoint.
#'
#' @inheritParams trade-parameters
#' @return A list.
#' @export
#'
#' @examples
#' \dontrun{
#' wallet_dust_transfer("ENJ")
#' }
wallet_dust_transfer <- function(coin) {
  coin <- validate_coin(coin)

  dust <- POST(
    "/sapi/v1/asset/dust",
    query = list(
      asset = coin
    ),
    simplifyVector = FALSE,
    security_type = "USER_DATA"
  )

  dust$transferResult <- dust$transferResult %>%
    bind_rows() %>%
    clean_names() %>%
    mutate(operate_time = parse_time(operate_time)) %>%
    mutate_at(vars(ends_with("amount")), as.numeric) %>%
    list()

  as_tibble(dust) %>%
    clean_names() %>%
    mutate_at(vars(starts_with("total")), as.numeric)
}

#' Log of dust
#'
#' Exposes the \code{POST /sapi/v1/asset/dribblet} endpoint.
#'
#' @inheritParams trade-parameters
#' @return A list.
#' @export
#'
#' @examples
#' \dontrun{
#' wallet_dust_log()
#' }
wallet_dust_log <- function(
  start_time = NULL,
  end_time = NULL
) {
  dribblets <- GET(
    "/sapi/v1/asset/dribblet",
    query = list(
      startTime = time_to_timestamp(start_time),
      endTime = time_to_timestamp(end_time)
    ),
    simplifyVector = FALSE,
    security_type = "USER_DATA"
  )$userAssetDribblets %>%
    map(function(dribblet) {
      dribblet$details <- dribblet$userAssetDribbletDetails %>%
        bind_rows() %>%
        clean_names() %>%
        mutate(operate_time = parse_time(operate_time)) %>%
        mutate_at(vars(ends_with("amount")), as.numeric) %>%
        list()
      dribblet$userAssetDribbletDetails <- NULL
      dribblet
    })

  dribblets %>%
    bind_rows() %>%
    clean_names() %>%
    mutate(operate_time = parse_time(operate_time)) %>%
    mutate_at(vars(ends_with("amount")), as.numeric)
}
