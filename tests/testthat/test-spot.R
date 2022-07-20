test_that("spot account", {
  account <- spot_account()

  expect_equal(account$account_type, "SPOT")
})

test_that("test new spot order", {
  expect_true(
    spot_new_order(
      order_type = "MARKET",
      symbol = "ETHUSDT",
      side = "BUY",
      quantity = 1,
      test = TRUE
    )
  )
})

test_that("MIN_NOTIONAL filter", {
  # Quantity is too small.
  expect_error(
    spot_new_order(
      order_type = "MARKET",
      symbol = "ETHUSDT",
      side = "BUY",
      quantity = 0.001
    ),
    "Filter failure: MIN_NOTIONAL"
  )
  # Quantity is not too small.
  expect_error(
    spot_new_order(
      order_type = "MARKET",
      symbol = "ETHUSDT",
      side = "BUY",
      quantity = 1
    ),
    NA
  )
})
