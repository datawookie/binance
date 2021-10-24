# See:
#
# - https://github.com/binance/binance-signature-examples
# - https://github.com/binance/binance-spot-api-docs/blob/master/rest-api.md#signed-trade-and-user_data-endpoint-security
#
test_that("signature", {
  expect_equal(
    binance:::signature(
      query = "symbol=LTCBTC&side=BUY&type=LIMIT&timeInForce=GTC&quantity=1&price=0.1&recvWindow=5000&timestamp=1499827319559",
      key = "NhqPtmdSJYdKjVHjA7PZj4Mge3R5YNiP1e3UZjInClVN65XAbvqqM6A7H5fATj0j"
    ),
    "c8db56825ae71d6d79447849e617115f4a920fa2acdcab2b053c4b2838bd6b71"
  )
  expect_equal(
    signature(
      query = "symbol=LTCBTC&side=BUY&type=LIMIT&timeInForce=GTC",
      body = "quantity=1&price=0.1&recvWindow=5000&timestamp=1499827319559",
      key = "NhqPtmdSJYdKjVHjA7PZj4Mge3R5YNiP1e3UZjInClVN65XAbvqqM6A7H5fATj0j"
    ),
    "0fd168b8ddb4876a0358a8d14d0c9f3da0e9b20c5d52b2a00fcf7d1c602f9a77"
  )
})
