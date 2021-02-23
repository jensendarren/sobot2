# Sobot

A trading bot built in Elixir. Based on [frathon/hedgehog](https://github.com/frathon/hedgehog).

## Running the app

First add your Binance API keys to the app [config](./config/config.exs) file.

Then, start the interactive Elixir REPL:

```
iex -S mix
```

Now in the _iex repl_, start the trader and then start streaming trade events for a symbol to the trader like so:

```
Naive.Trader.start_link(%{symbol: "XRPUSDT", profit_interval: Decimal.new("-0.01")})
Streamer.start_streaming("xrpusdt")
```

**NOTE** If you have added your Binance API keys and you have USDT in your account this process will BUY XRP and SELL the position immediately and then the bot will stop. Its just a test and not ment to make any money at all! :)