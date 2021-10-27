
<!-- README.md is generated from README.Rmd. Please edit that file -->

# binance <img src="man/figures/binance-hex.png" align="right" alt="" width="120" />

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/binance)](https://cran.r-project.org/package=binance)
![GitHub Actions build
status](https://github.com/datawookie/binance/actions/workflows/build.yaml/badge.svg)
[![Codecov test
coverage](https://img.shields.io/codecov/c/github/datawookie/binance.svg)](https://codecov.io/github/datawookie/binance)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html)
<!-- badges: end -->

`{binance}` is a wrapper for the [Binance
API](https://binance-docs.github.io/apidocs/spot/en/). The documentation
for `{binance}` can be found
[here](https://datawookie.github.io/binance/).

## Installation

Install the development version from GitHub.

``` r
remotes::install_github("datawookie/binance")
```

## Load the Library

Load the library.

``` r
library(binance)
```

## Authenticate

Many of the functions are available without authentication. However, if
you want to access information relating to your wallet or trades then
you’ll need to create an API key and secret.

``` r
authenticate(
  key = Sys.getenv("BINANCE_API_KEY"),
  secret = Sys.getenv("BINANCE_API_SECRET")
)
```

## Endpoints

The Binance API is extensive. Below is the current coverage of the
`{binance}` package.

-   [ ] `GET /sapi/v1/system/status`
-   [x] `GET /sapi/v1/capital/config/getall (HMAC SHA256)`
-   [ ] `GET /sapi/v1/accountSnapshot (HMAC SHA256)`
-   [ ] `POST /sapi/v1/account/disableFastWithdrawSwitch (HMAC SHA256)`
-   [ ] `POST /sapi/v1/account/enableFastWithdrawSwitch (HMAC SHA256)`
-   [ ] `POST /sapi/v1/capital/withdraw/apply (HMAC SHA256)`
-   [ ] `GET /sapi/v1/capital/deposit/hisrec (HMAC SHA256)`
-   [ ] `GET /sapi/v1/capital/withdraw/history (HMAC SHA256)`
-   [ ] `GET /sapi/v1/capital/deposit/address (HMAC SHA256)`
-   [ ] `GET /sapi/v1/account/status`
-   [ ] `GET /sapi/v1/account/apiTradingStatus (HMAC SHA256)`
-   [ ] `GET /sapi/v1/asset/dribblet (HMAC SHA256)`
-   [ ] `POST /sapi/v1/asset/dust (HMAC SHA256)`
-   [ ] `GET /sapi/v1/asset/assetDividend (HMAC SHA256)`
-   [ ] `GET /sapi/v1/asset/assetDetail (HMAC SHA256)`
-   [ ] `GET /sapi/v1/asset/tradeFee (HMAC SHA256)`
-   [ ] `POST /sapi/v1/asset/transfer (HMAC SHA256)`
-   [ ] `GET /sapi/v1/asset/transfer (HMAC SHA256)`
-   [ ] `POST /sapi/v1/asset/get-funding-asset (HMAC SHA256)`
-   [ ] `GET /sapi/v1/account/apiRestrictions (HMAC SHA256)`
-   [ ] `POST /sapi/v1/sub-account/virtualSubAccount (HMAC SHA256)`
-   [ ] `GET /sapi/v1/sub-account/list (HMAC SHA256)`
-   [ ] `GET /sapi/v1/sub-account/sub/transfer/history (HMAC SHA256)`
-   [ ]
    `GET /sapi/v1/sub-account/futures/internalTransfer (HMAC SHA256)`
-   [ ]
    `POST /sapi/v1/sub-account/futures/internalTransfer (HMAC SHA256)`
-   [ ] `GET /sapi/v3/sub-account/assets (HMAC SHA256)`
-   [ ] `GET /sapi/v1/capital/deposit/subAddress (HMAC SHA256)`
-   [ ] `GET /sapi/v1/capital/deposit/subHisrec (HMAC SHA256)`
-   [ ] `GET /sapi/v1/sub-account/status (HMAC SHA256)`
-   [ ] `POST /sapi/v1/sub-account/margin/enable (HMAC SHA256)`
-   [ ] `GET /sapi/v1/sub-account/margin/account (HMAC SHA256)`
-   [ ] `GET /sapi/v1/sub-account/margin/accountSummary (HMAC SHA256)`
-   [ ] `POST /sapi/v1/sub-account/futures/enable (HMAC SHA256)`
-   [ ] `GET /sapi/v1/sub-account/futures/account (HMAC SHA256)`
-   [ ] `GET /sapi/v1/sub-account/futures/accountSummary (HMAC SHA256)`
-   [ ] `GET /sapi/v1/sub-account/futures/positionRisk (HMAC SHA256)`
-   [ ] `POST /sapi/v1/sub-account/futures/transfer (HMAC SHA256)`
-   [ ] `POST /sapi/v1/sub-account/margin/transfer (HMAC SHA256)`
-   [ ] `POST /sapi/v1/sub-account/transfer/subToSub (HMAC SHA256)`
-   [ ] `POST /sapi/v1/sub-account/transfer/subToMaster (HMAC SHA256)`
-   [ ] `GET /sapi/v1/sub-account/transfer/subUserHistory (HMAC SHA256)`
-   [ ] `POST /sapi/v1/sub-account/universalTransfer (HMAC SHA256)`
-   [ ] `GET /sapi/v1/sub-account/universalTransfer (HMAC SHA256)`
-   [ ] `GET /sapi/v2/sub-account/futures/account (HMAC SHA256)`
-   [ ] `GET /sapi/v2/sub-account/futures/accountSummary (HMAC SHA256)`
-   [ ] `GET /sapi/v2/sub-account/futures/positionRisk (HMAC SHA256)`
-   [ ] `POST /sapi/v1/sub-account/blvt/enable (HMAC SHA256)`
-   [ ] `POST /sapi/v1/managed-subaccount/deposit (HMAC SHA256)`
-   [ ] `GET /sapi/v1/managed-subaccount/asset (HMAC SHA256)`
-   [ ] `POST /sapi/v1/managed-subaccount/withdraw (HMAC SHA256)`
-   [x] `GET /api/v3/ping`
-   [ ] `GET /api/v3/time`
-   [ ] `GET /api/v3/exchangeInfo`
-   [ ] `GET /api/v3/depth`
-   [x] `GET /api/v3/trades`
-   [ ] `GET /api/v3/historicalTrades`
-   [ ] `GET /api/v3/aggTrades`
-   [x] `GET /api/v3/klines`
-   [x] `GET /api/v3/avgPrice`
-   [ ] `GET /api/v3/ticker/24hr`
-   [ ] `GET /api/v3/ticker/price`
-   [ ] `GET /api/v3/ticker/bookTicker`
-   [ ] `POST /api/v3/order/test (HMAC SHA256)`
-   [ ] `POST /api/v3/order (HMAC SHA256)`
-   [ ] `DELETE /api/v3/order (HMAC SHA256)`
-   [ ] `DELETE /api/v3/openOrders`
-   [ ] `GET /api/v3/order (HMAC SHA256)`
-   [ ] `GET /api/v3/openOrders (HMAC SHA256)`
-   [ ] `GET /api/v3/allOrders (HMAC SHA256)`
-   [ ] `POST /api/v3/order/oco (HMAC SHA256)`
-   [ ] `DELETE /api/v3/orderList (HMAC SHA256)`
-   [ ] `GET /api/v3/orderList (HMAC SHA256)`
-   [ ] `GET /api/v3/allOrderList (HMAC SHA256)`
-   [ ] `GET /api/v3/openOrderList (HMAC SHA256)`
-   [x] `GET /api/v3/account (HMAC SHA256)`
-   [x] `GET /api/v3/myTrades (HMAC SHA256)`
-   [ ] `POST /sapi/v1/margin/transfer (HMAC SHA256)`
-   [ ] `POST /sapi/v1/margin/loan (HMAC SHA256)`
-   [ ] `POST /sapi/v1/margin/repay (HMAC SHA256)`
-   [ ] `GET /sapi/v1/margin/asset`
-   [ ] `GET /sapi/v1/margin/pair`
-   [ ] `GET /sapi/v1/margin/allAssets`
-   [ ] `GET /sapi/v1/margin/allPairs`
-   [ ] `GET /sapi/v1/margin/priceIndex`
-   [ ] `POST /sapi/v1/margin/order (HMAC SHA256)`
-   [ ] `DELETE /sapi/v1/margin/order (HMAC SHA256)`
-   [ ] `DELETE /sapi/v1/margin/openOrders (HMAC SHA256)`
-   [ ] `GET /sapi/v1/margin/transfer (HMAC SHA256)`
-   [ ] `GET /sapi/v1/margin/loan (HMAC SHA256)`
-   [ ] `GET /sapi/v1/margin/repay (HMAC SHA256)`
-   [ ] `GET /sapi/v1/margin/interestHistory (HMAC SHA256)`
-   [ ] `GET /sapi/v1/margin/forceLiquidationRec (HMAC SHA256)`
-   [ ] `GET /sapi/v1/margin/account (HMAC SHA256)`
-   [ ] `GET /sapi/v1/margin/order (HMAC SHA256)`
-   [ ] `GET /sapi/v1/margin/openOrders (HMAC SHA256)`
-   [ ] `GET /sapi/v1/margin/allOrders (HMAC SHA256)`
-   [ ] `POST /sapi/v1/margin/order/oco (HMAC SHA256)`
-   [ ] `DELETE /sapi/v1/margin/orderList (HMAC SHA256)`
-   [ ] `GET /sapi/v1/margin/orderList (HMAC SHA256)`
-   [ ] `GET /sapi/v1/margin/allOrderList (HMAC SHA256)`
-   [ ] `GET /sapi/v1/margin/openOrderList (HMAC SHA256)`
-   [ ] `GET /sapi/v1/margin/myTrades (HMAC SHA256)`
-   [ ] `GET /sapi/v1/margin/maxBorrowable (HMAC SHA256)`
-   [ ] `GET /sapi/v1/margin/maxTransferable (HMAC SHA256)`
-   [ ] `POST /sapi/v1/margin/isolated/transfer (HMAC SHA256)`
-   [ ] `GET /sapi/v1/margin/isolated/transfer (HMAC SHA256)`
-   [ ] `GET /sapi/v1/margin/isolated/account (HMAC SHA256)`
-   [ ] `DELETE /sapi/v1/margin/isolated/account (HMAC SHA256)`
-   [ ] `POST /sapi/v1/margin/isolated/account (HMAC SHA256)`
-   [ ] `GET /sapi/v1/margin/isolated/accountLimit (HMAC SHA256)`
-   [ ] `GET /sapi/v1/margin/isolated/pair (HMAC SHA256)`
-   [ ] `GET /sapi/v1/margin/isolated/allPairs (HMAC SHA256)`
-   [ ] `POST /sapi/v1/bnbBurn (HMAC SHA256)`
-   [ ] `GET /sapi/v1/bnbBurn (HMAC SHA256)`
-   [ ] `GET /sapi/v1/margin/interestRateHistory (HMAC SHA256)`
-   [ ] `POST /api/v3/userDataStream`
-   [ ] `DELETE /api/v3/userDataStream`
-   [ ] `POST /sapi/v1/userDataStream`
-   [ ] `DELETE /sapi/v1/userDataStream`
-   [ ] `POST /sapi/v1/userDataStream/isolated`
-   [ ] `DELETE /sapi/v1/userDataStream/isolated`
-   [ ] `GET /sapi/v1/lending/daily/product/list (HMAC SHA256)`
-   [ ] `GET /sapi/v1/lending/daily/userLeftQuota (HMAC SHA256)`
-   [ ] `POST /sapi/v1/lending/daily/purchase (HMAC SHA256)`
-   [ ] `GET /sapi/v1/lending/daily/userRedemptionQuota (HMAC SHA256)`
-   [ ] `POST /sapi/v1/lending/daily/redeem (HMAC SHA256)`
-   [ ] `GET /sapi/v1/lending/daily/token/position (HMAC SHA256)`
-   [ ] `GET /sapi/v1/lending/project/list (HMAC SHA256)`
-   [ ] `POST /sapi/v1/lending/customizedFixed/purchase (HMAC SHA256)`
-   [ ] `GET /sapi/v1/lending/project/position/list (HMAC SHA256)`
-   [ ] `GET /sapi/v1/lending/union/account (HMAC SHA256)`
-   [ ] `GET /sapi/v1/lending/union/purchaseRecord (HMAC SHA256)`
-   [ ] `GET /sapi/v1/lending/union/redemptionRecord (HMAC SHA256)`
-   [ ] `GET /sapi/v1/lending/union/interestHistory (HMAC SHA256)`
-   [ ] `POST /sapi/v1/lending/positionChanged (HMAC SHA256)`
-   [ ] `GET /sapi/v1/mining/pub/algoList (HMAC SHA256)`
-   [ ] `GET /sapi/v1/mining/worker/detail (HMAC SHA256)`
-   [ ] `GET /sapi/v1/mining/worker/list (HMAC SHA256)`
-   [ ] `GET /sapi/v1/mining/payment/list (HMAC SHA256)`
-   [ ] `GET /sapi/v1/mining/payment/other (HMAC SHA256)`
-   [ ]
    `GET /sapi/v1/mining/hash-transfer/config/details/list (HMAC SHA256)`
-   [ ] `GET /sapi/v1/mining/hash-transfer/profit/details (HMAC SHA256)`
-   [ ] `POST /sapi/v1/mining/hash-transfer/config (HMAC SHA256)`
-   [ ] `POST /sapi/v1/mining/hash-transfer/config/cancel (HMAC SHA256)`
-   [ ] `GET /sapi/v1/mining/statistics/user/status (HMAC SHA256)`
-   [ ] `GET /sapi/v1/mining/statistics/user/list (HMAC SHA256)`
-   [ ] `POST /sapi/v1/futures/transfer (HMAC SHA256)`
-   [ ] `GET /sapi/v1/futures/transfer (HMAC SHA256)`
-   [ ] `POST /sapi/v1/futures/loan/borrow (HMAC SHA256)`
-   [ ] `GET /sapi/v1/futures/loan/borrow/history (HMAC SHA256)`
-   [ ] `POST /sapi/v1/futures/loan/repay (HMAC SHA256)`
-   [ ] `GET /sapi/v1/futures/loan/repay/history HMAC SHA256)`
-   [ ] `GET /sapi/v1/futures/loan/wallet (HMAC SHA256)`
-   [ ] `GET /sapi/v2/futures/loan/wallet (HMAC SHA256)`
-   [ ] `GET /sapi/v1/futures/loan/configs (HMAC SHA256)`
-   [ ] `GET /sapi/v2/futures/loan/configs (HMAC SHA256)`
-   [ ] `GET /sapi/v1/futures/loan/calcAdjustLevel (HMAC SHA256)`
-   [ ] `GET /sapi/v2/futures/loan/calcAdjustLevel (HMAC SHA256)`
-   [ ] `GET /sapi/v1/futures/loan/calcMaxAdjustAmount (HMAC SHA256)`
-   [ ] `GET /sapi/v2/futures/loan/calcMaxAdjustAmount (HMAC SHA256)`
-   [ ] `POST /sapi/v1/futures/loan/adjustCollateral (HMAC SHA256)`
-   [ ] `POST /sapi/v2/futures/loan/adjustCollateral (HMAC SHA256)`
-   [ ]
    `GET /sapi/v1/futures/loan/adjustCollateral/history (HMAC SHA256)`
-   [ ] `GET /sapi/v1/futures/loan/liquidationHistory (HMAC SHA256)`
-   [ ] `GET /sapi/v1/futures/loan/collateralRepayLimit (HMAC SHA256)`
-   [ ] `GET /sapi/v1/futures/loan/collateralRepay (HMAC SHA256)`
-   [ ] `POST /sapi/v1/futures/loan/collateralRepay (HMAC SHA256)`
-   [ ] `GET /sapi/v1/futures/loan/collateralRepayResult (HMAC SHA256)`
-   [ ] `GET /sapi/v1/futures/loan/interestHistory (HMAC SHA256)`
-   [ ] `GET /sapi/v1/blvt/tokenInfo`
-   [ ] `POST /sapi/v1/blvt/subscribe (HMAC SHA256)`
-   [ ] `GET /sapi/v1/blvt/subscribe/record (HMAC SHA256)`
-   [ ] `POST /sapi/v1/blvt/redeem (HMAC SHA256)`
-   [ ] `GET /sapi/v1/blvt/redeem/record (HMAC SHA256)`
-   [ ] `GET /sapi/v1/blvt/userLimit (HMAC SHA256)`
-   [ ] `GET /sapi/v1/bswap/pools`
-   [ ] `GET /sapi/v1/bswap/liquidity (HMAC SHA256)`
-   [ ] `POST /sapi/v1/bswap/liquidityAdd (HMAC SHA256)`
-   [ ] `POST /sapi/v1/bswap/liquidityRemove (HMAC SHA256)`
-   [ ] `GET /sapi/v1/bswap/liquidityOps (HMAC SHA256)`
-   [ ] `GET /sapi/v1/bswap/quote (HMAC SHA256)`
-   [ ] `POST /sapi/v1/bswap/swap (HMAC SHA256)`
-   [ ] `GET /sapi/v1/bswap/swap (HMAC SHA256)`
-   [ ] `GET /sapi/v1/bswap/poolConfigure (HMAC SHA256)`
-   [ ] `GET /sapi/v1/bswap/addLiquidityPreview (HMAC SHA256)`
-   [ ] `GET /sapi/v1/bswap/removeLiquidityPreview (HMAC SHA256)`
-   [ ] `GET /sapi/v1/fiat/orders (HMAC SHA256)`
-   [ ] `GET /sapi/v1/fiat/payments (HMAC SHA256)`
-   [ ] `GET /sapi/v1/c2c/orderMatch/listUserOrderHistory (HMAC SHA256)`
