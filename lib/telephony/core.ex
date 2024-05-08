defmodule Telephony.Core do
  alias __MODULE__.Subscriber

  @subscriber_types [:prepaid, :pospaid]

  def create_subscriber(subscribers, %{type: type} = payload)
      when type in @subscriber_types do
    case Enum.find(subscribers, fn s -> s.phone_number == payload.phone_number end) do
      nil ->
        subscriber = Subscriber.new(payload)
        subscribers ++ [subscriber]

      subscriber ->
        {:error, "Subscriber `#{subscriber.phone_number}` already exist"}
    end
  end

  def create_subscriber(_subscribers, _payload) do
    {:error, "Only 'prepaid' or 'postpaid' are accepted"}
  end

  def search_subscriber(subscribers, phone_number) do
    Enum.find(subscribers, &(&1.phone_number == phone_number))
  end

  def make_recharge(subscribers, phone_number, value, date) do
    case subscribers
         |> search_subscriber(phone_number) do
      nil -> subscribers
      subscriber -> make_recharge_and_update_subscribers(subscribers, subscriber, value, date)
    end
  end

  # could add make_call and print_invoice...

  defp make_recharge_and_update_subscribers(subscribers, subscriber, value, date) do
    case Subscriber.make_recharge(subscriber, value, date) do
      {:error, _} ->
        subscribers

      updated_subscriber ->
        subscribers = List.delete(subscribers, subscriber)
        subscribers ++ [updated_subscriber]
    end
  end
end
