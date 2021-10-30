test_that("spot account", {
  account <- spot_account()

  expect_equal(account$account_type, "SPOT")
})
