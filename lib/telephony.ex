defmodule Telephony do
  @server :telephony

  def create_subscriber(payload) do
    GenServer.call(@server, {:create_subscriber, payload})
  end

  def search_subscriber(phone_number) do
    GenServer.call(@server, {:search_subscriber, phone_number})
  end
end
