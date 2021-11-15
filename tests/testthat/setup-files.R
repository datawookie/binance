base_url("https://testnet.binance.vision/")

message("Base URL: ", base_url())

authenticate(
  key = Sys.getenv("BINANCE_TESTNET_API_KEY"),
  secret = Sys.getenv("BINANCE_TESTNET_API_SECRET")
)
