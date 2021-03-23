defmodule DataWarehouse.Subscribers.Worker do
  use GenServer

  require Logger

  defmodule State do
    @enforce_keys [:stream_name, :symbol]
    defstruct [:stream_name, :symbol]
  end

  def start_link(%{stream_name: stream_name, symbol: symbol} = args) do
    GenServer.start_link(
      __MODULE__,
      args,
      name: :"#{__MODULE__}-#{stream_name}-#{symbol}"
    )
  end

  def init(%{stream_name: stream_name, symbol: symbol} = args) do
    topic = "#{stream_name}:#{symbol}"
    Logger.info("DataWarehouse worker is subscribing to #{topic}")

    Phoenix.PubSub.subscribe(
      Streamer.PubSub,
      topic
    )

    {:ok, struct!(State, args)}
  end

  def handle_info(%Streamer.Binance.TradeEvent{} = trade_event, state) do
    opts =
      trade_event
      |> Map.from_struct()

    struct!(DataWarehouse.Schema.TradeEvent, opts)
    |> DataWarehouse.Repo.insert()

    {:noreply, state}
  end

  def handle_info(%Binance.Order{} = order, state) do
    data =
      order
      |> Map.from_struct()

    struct(DataWarehouse.Schema.Order, data)
    |> Map.merge(%{
      original_quantity: order.orig_qty,
      executed_quantity: order.executed_qty,
      cummulative_quote_quantity: order.cummulative_quote_qty,
      iceberg_quantity: order.iceberg_qty
    })
    |> DataWarehouse.Repo.insert(
      on_conflict: :replace_all,
      conflict_target: :order_id
    )

    {:noreply, state}
  end
end
