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
end
