defmodule Telephony.CoreTest do
  use ExUnit.Case

  alias Telephony.Core.Subscriber
  alias Telephony.Core

  setup do
    subscribers = [
      %Subscriber{
        full_name: "Estevan",
        phone_number: "123",
        subscriber_type: :prepaid
      }
    ]

    payload = %{
      full_name: "Estevan",
      phone_number: "123",
      subscriber_type: :prepaid
    }

    %{
      subscribers: subscribers,
      payload: payload
    }
  end

  test "create a new subscriber", %{subscribers: subscribers, payload: payload} do
    result = Core.create_subscriber([], payload)

    assert result == subscribers
  end

  test "display error, when subscriber already exist", %{
    subscribers: subscribers,
    payload: payload
  } do
    result = Core.create_subscriber(subscribers, payload)
    {:error, "Subscriber `123` already exist"} = result
  end

  test "display error, when subscriber_type does not exist", %{
    payload: payload
  } do
    payload = Map.put(payload, :subscriber_type, :shausuha)
    result = Core.create_subscriber([], payload)
    {:error, "Only 'prepaid' or 'postpaid' are accepted"} = result
  end
end
