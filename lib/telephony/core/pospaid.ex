defmodule Telephony.Core.Pospaid do
  alias Telephony.Core.Call

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

  defp update_spent(%{subscriber_type: subscriber_type} = subscriber, time_spent) do
    spent = @price_per_minute * time_spent
    subscriber_type = %{subscriber_type | spent: subscriber_type.spent + spent}
    %{subscriber | subscriber_type: subscriber_type}
  end

  defp update_call(subscriber, time_spent, date) do
    call = Call.new(time_spent, date)
    %{subscriber | calls: subscriber.calls ++ [call]}
  end
end
