# Sobot

A trading bot built in Elixir. Based on [frathon/hedgehog](https://github.com/frathon/hedgehog).

## Running the app (with the live Binance client)

First add your Binance API keys to the app [config](./config/config.exs) file.

Also, in the same config file, set `binance_client: Binance` (so that it uses the live client for trading and not the mock). If you want to use mock client then keep the config set to `binance_client: BinanceMock` (so that real trades will not be placed in Binance).

Start the Postgress database running via Docker Compose:

```
docker-compose up
```

**If you have not done so already**, seed the database with the default config for all the symbols:

```
cd apps/naive
mix run priv/seed_settings.exs
```

You can check directly in the database using (at the password prompt its `postgress`)

```
psql -Upostgres -hlocalhost
\c naive
\d settings
select id, symbol, budget, status from settings;
```

Now, start the interactive Elixir REPL:

```
cd apps/naive
iex -S mix
```

If you are using the `BinanceMock` you can check its running.

```
Process.whereis(BinanceMock)
```

Now start the trader and then start streaming trade events for a symbol to the trader like so:

```
Streamer.start_streaming("NEOUSDT")
Naive.start_trading("NEOUSDT")
```

You can also start an Elixir observer like so (from withing the iex session):

```
:observer.start()
```

**NOTE** If you have added your Binance API keys and you have USDT in your account (and you are using the live Binance app - not the BinanceMock) this process will BUY XRP and SELL the position immediately and then the bot will stop. Its just a test and not ment to make any money at all! :)