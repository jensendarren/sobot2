# Sobot

A trading bot built in Elixir. Based on [frathon/hedgehog](https://github.com/frathon/hedgehog).

## Running the app

```
cd apps/streamer
iex -S mix
```

Now in the _iex repl_, start streaming trade events for a symbol:

```
Streamer.start_streaming("xrpusdt")
```