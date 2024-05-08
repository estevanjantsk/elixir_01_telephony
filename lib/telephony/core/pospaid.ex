defmodule Telephony.Core.Pospaid do
  alias Telephony.Core.{Call, Invoice, Pospaid}

  defstruct spent: 0

  @price_per_minute 1.04

  def new(payload) do
    struct(__MODULE__, payload)
  end

  def make_call(subscriber, time_spent, date) do
    subscriber
    |> update_spent(time_spent)
    |> update_call(time_spent, date)
  end

  def get_value_spent(time) do
    time * @price_per_minute
  end

  defp update_spent(%{type: type} = subscriber, time_spent) do
    spent = @price_per_minute * time_spent
    type = %{type | spent: type.spent + spent}
    %{subscriber | type: type}
  end

  defp update_call(subscriber, time_spent, date) do
    call = Call.new(time_spent, date)
    %{subscriber | calls: subscriber.calls ++ [call]}
  end

  defimpl Invoice, for: Telephony.Core.Pospaid do
    def print(%Pospaid{spent: spent} = _subscriber_type, calls, year, month) do
      calls =
        Enum.reduce(calls, [], fn call, acc ->
          value_spent = Pospaid.get_value_spent(call.time_spent)

          if(call.date.year == year and call.date.month == month) do
            call = %{date: call.date, time_spent: call.time_spent, value_spent: value_spent}
            acc ++ [call]
          else
            acc
          end
        end)

      %{
        spent: spent,
        calls: calls
      }
    end
  end
end
