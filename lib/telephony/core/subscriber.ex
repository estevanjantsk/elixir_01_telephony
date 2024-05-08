defmodule Telephony.Core.Subscriber do
  alias Telephony.Core.{Prepaid, Pospaid, Invoice}

  defstruct full_name: nil, phone_number: nil, subscriber_type: :prepaid, calls: []

  def new(%{subscriber_type: :prepaid} = payload) do
    payload = %{payload | subscriber_type: %Prepaid{}}
    struct(__MODULE__, payload)
  end

  def new(%{subscriber_type: :pospaid} = payload) do
    payload = %{payload | subscriber_type: %Pospaid{}}
    struct(__MODULE__, payload)
  end

  # Print
  def print_invoice(%{subscriber_type: subscriber_type} = _subscriber, calls, year, month),
    do: Invoice.print(subscriber_type, calls, year, month)

  # Make call
  def make_call(%{subscriber_type: %Prepaid{}} = subscriber, time_spent, date),
    do: Prepaid.make_call(subscriber, time_spent, date)

  def make_call(%{subscriber_type: %Pospaid{}} = subscriber, time_spent, date),
    do: Pospaid.make_call(subscriber, time_spent, date)

  # Make recharge
  def make_recharge(%{subscriber_type: %Prepaid{}} = subscriber, value, date),
    do: Prepaid.make_recharge(subscriber, value, date)

  def make_recharge(_subscriber, _value, _date),
    do: {:error, "Only prepaid can make a recharge"}
end
