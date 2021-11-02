#' Search P2P
#'
#' @param pay_types Options for payment. One or more of \code{"BANK"},
#'   \code{"WECHAT"} or \code{"ALIPAY"}. The default, \code{NA}, allows all
#'   payment options.
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' # Grab the first page.
#' p2p_search("USDT", "CNY", side = "BUY")
#' # Grab the second page.
#' p2p_search("USDT", "CNY", side = "BUY", page = 2)
#'
#' # Concatenate multiple pages.
#' map_dfr(
#'   1:3,
#'   function(page) p2p_search("USDT", "CNY", side = "BUY", page = page)
#' )
p2p_search <- function(
  asset,
  fiat,
  side,
  pay_types = NA,
  page = 1,
  rows = 10
) {
  body <- list(
    page = page,
    rows = rows,
    # payTypes = pay_types,
    payTypes = c(),
    asset = asset,
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
  offers <- binance:::POST(
    "/bapi/c2c/v2/friendly/c2c/adv/search",
    body = body,
    base_url = "https://p2p.binance.com/"
  )

  offers$data %>%
    map_dfr(function(offer) {
      advertiser = offer$advertiser
      trade = offer$adv
      tibble(
        advertiser = list(tibble(
          id = advertiser$userNo,
          name = advertiser$nickName,
          type = advertiser$userType,
          orders = advertiser$monthOrderCount,
          completion = advertiser$monthFinishRate
        )),
        # The side is from the perspective of the advertiser.
        side = flip_side(trade$tradeType),
        asset = trade$asset,
        fiat = trade$fiatUnit,
        price = as.numeric(trade$price),
        available = as.numeric(trade$tradableQuantity),
        min_amount = as.numeric(trade$minSingleTransAmount),
        max_amount = as.numeric(trade$dynamicMaxSingleTransAmount),
        payment = list(
          map_dfr(trade$tradeMethods, function(method) {
            list(
              type = method$payType,
              name = method$tradeMethodName
            )
          })
        )
      )
    })
}
