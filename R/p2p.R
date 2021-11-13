prepare_trade_methods <- function(methods) {
  list(
    map_dfr(methods, function(method) {
      method <- list_null_to_na(method)
      tibble(
        type = method$payType,
        name = method$tradeMethodName
      )
    })
  )
}

prepare_adverts <- function(adverts) {
  adverts %>% map_dfr(function(adv) {
    adv$tradeMethodCommissionRates <- NULL
    adv$advVisibleRet <- NULL
    adv$tradeMethods <- prepare_trade_methods(adv$tradeMethods)
    adv %>%
      list_null_to_na() %>%
      as_tibble()
  }) %>% clean_names()
}

#' Search P2P
#'
#' @inheritParams trade-parameters
#' @inheritParams pagination
#' @param pay_types Options for payment. One or more of \code{"BANK"},
#'   \code{"WECHAT"} or \code{"ALIPAY"}. The default, \code{c()}, allows all
#'   payment options.
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' # Grab the first page.
#' p2p_search("ETH", "USD", side = "BUY", page = 1)
#' # Grab all pages.
#' p2p_search("ETH", "USD", side = "BUY")
p2p_search <- function(
  coin,
  fiat,
  side,
  pay_types = c(),
  page = NA,
  rows = 10
) {
  if (is.na(page)) {
    args <- as.list(environment())

    offers <- list()
    page <- 0

    while (TRUE) {
      page <- page + 1
      log_debug("Retrieve page {page}.")
      args$page <- page
      batch <- do.call(p2p_search, args)

      records <- nrow(batch)
      log_debug("{records} records.")

      if (records > 0) {
        offers <- c(offers, list(batch))
      }
      if (records < rows) break
    }
    bind_rows(offers)
  } else {
    body <- list(
      page = page,
      rows = rows,
      payTypes = pay_types,
      asset = coin,
      fiat = fiat,
      tradeType = side,
      publisherType = NULL
    )
    body <- jsonlite::toJSON(body, null = "null", auto_unbox = TRUE)
    #
    # Sample body looks like this:
    #
    # '{"page":1,"rows":10,"payTypes":[],"asset":"USDT","tradeType":"BUY","fiat":"CNY","publisherType":null}'
    #
    offers <- POST(
      "/bapi/c2c/v2/friendly/c2c/adv/search",
      body = body,
      base_url = "https://p2p.binance.com/"
    )

    offers$data %>%
      map_dfr(function(offer) {
        advertiser = offer$advertiser
        trade = offer$adv
        tibble(
          advert_id = trade$advNo,
          # The side is from the perspective of the advertiser.
          side = flip_side(trade$tradeType),
          asset = trade$asset,
          fiat = trade$fiatUnit,
          price = as.numeric(trade$price),
          available = as.numeric(trade$tradableQuantity),
          min_amount = as.numeric(trade$minSingleTransAmount),
          max_amount = as.numeric(trade$dynamicMaxSingleTransAmount),
          advertiser = list(tibble(
            id = advertiser$userNo,
            name = advertiser$nickName,
            type = advertiser$userType,
            orders = advertiser$monthOrderCount,
            completion = advertiser$monthFinishRate
          )),
          payment = prepare_trade_methods(trade$tradeMethods)
        )
      })
  }
}

#' Data for P2P Advertiser
#'
#' @param advertiser_id Advertiser ID.
#'
#' @return A tibble.
#' @export
#'
#' @examples
#' p2p_advertiser_detail("saee1afc6b3133e7987e81020003f9707")
p2p_advertiser_detail <- function(advertiser_id) {
  advertiser <- GET(
    "/bapi/c2c/v2/friendly/c2c/user/profile-and-ads-list",
    query = list(
      userNo = advertiser_id
    ),
    base_url = "https://p2p.binance.com/"
  )$data

  advertiser$userDetailVo %>%
    make_clean_names_recursive() %>%
    list_null_to_na() %>%
    modify_if(is.list, ~ list(as_tibble(.))) %>%
    as_tibble() %>%
    mutate(
      buy_list = list(prepare_adverts(advertiser$buyList)),
      sell_list = list(prepare_adverts(advertiser$sellList))
    )
}

#' Get P2P order history
#'
#' @return A tibble.
#' @export
p2p_order_history <- function(side) {
  side <- check_order_side(side)

  orders <- binance:::GET(
    "/sapi/v1/c2c/orderMatch/listUserOrderHistory",
    query = list(
      tradeType = side
    ),
    simplifyVector = FALSE,
    security_type = "USER_DATA"
  )

  if (orders$total > 0) {
    orders$data %>%
      bind_rows() %>%
      clean_names() %>%
      fix_types()
  } else {
    NULL
  }
}
