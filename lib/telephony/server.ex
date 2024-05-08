defmodule Telephony.Server do
  @behaviour GenServer

  alias Telephony.Core

  def start_link(server_name) do
    GenServer.start_link(__MODULE__, [], name: server_name)
  end

  def init(subscribers) do
    {:ok, subscribers}
  end

  def handle_call({:create_subscriber, payload}, _from, subscribers) do
    case Core.create_subscriber(subscribers, payload) do
      {:error, _} = err -> {:reply, err, subscribers}
      subscribers -> {:reply, subscribers, subscribers}
    end
  end

  def handle_call({:search_subscriber, phone_number}, _from, subscribers) do
    case Core.search_subscriber(subscribers, phone_number) do
      nil -> {:reply, {:error, "Subscriber not found"}, subscribers}
      subscriber -> {:reply, subscriber, subscribers}
    end
  end
end
