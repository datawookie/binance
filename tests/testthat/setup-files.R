base_url("https://testnet.binance.vision/")

message("Base URL: ", base_url())

message(nchar(Sys.getenv("BINANCE_TESTNET_API_KEY")))
message(nchar(Sys.getenv("BINANCE_TESTNET_API_SECRET")))
message("XXX:", Sys.getenv("BINANCE_TESTNET_API_KEY"), ":YYY")
message("XXX:", Sys.getenv("BINANCE_TESTNET_API_SECRET"), ":YYY")

authenticate(
  key = Sys.getenv("BINANCE_TESTNET_API_KEY"),
  secret = Sys.getenv("BINANCE_TESTNET_API_SECRET")
)
