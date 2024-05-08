defmodule Telephony.Core.Subscriber do
  alias Telephony.Core.{Prepaid, Pospaid, Invoice}

  defstruct full_name: nil, phone_number: nil, type: :prepaid, calls: []

  def new(%{type: :prepaid} = payload) do
    payload = %{payload | type: %Prepaid{}}
    struct(__MODULE__, payload)
  end

  def new(%{type: :pospaid} = payload) do
    payload = %{payload | type: %Pospaid{}}
    struct(__MODULE__, payload)
  end

  # Print
  def print_invoice(%{type: type} = _subscriber, calls, year, month),
    do: Invoice.print(type, calls, year, month)

  # Make call
  def make_call(%{type: %Prepaid{}} = subscriber, time_spent, date) do
    case Prepaid.make_call(subscriber, time_spent, date) do
      {:error, reason} -> {:error, reason}
      subscriber -> subscriber
    end
  end

  def make_call(%{type: %Pospaid{}} = subscriber, time_spent, date),
    do: Pospaid.make_call(subscriber, time_spent, date)

  # Make recharge
  def make_recharge(%{type: %Prepaid{}} = subscriber, value, date),
    do: Prepaid.make_recharge(subscriber, value, date)

  def make_recharge(_subscriber, _value, _date),
    do: {:error, "Only prepaid can make a recharge"}
end
