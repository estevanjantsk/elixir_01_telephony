defmodule Telephony.CoreTest do
  use ExUnit.Case

  alias Telephony.Core.{Subscriber, Prepaid}
  alias Telephony.Core

  setup do
    subscribers = [
      %Subscriber{
        full_name: "Estevan",
        phone_number: "123",
        type: %Prepaid{credits: 0, recharges: []}
      },
      %Subscriber{
        full_name: "Estevan 2",
        phone_number: "1232",
        type: %Prepaid{credits: 1, recharges: []}
      }
    ]

    payload = %{
      full_name: "Estevan Payload",
      phone_number: "123",
      type: :prepaid
    }

    %{
      subscribers: subscribers,
      payload: payload
    }
  end

  test "create a new subscriber", %{payload: payload} do
    expect = [
      %Telephony.Core.Subscriber{
        full_name: "Estevan Payload",
        phone_number: "123",
        type: %Telephony.Core.Prepaid{credits: 0, recharges: []},
        calls: []
      }
    ]

    result = Core.create_subscriber([], payload)

    assert result == expect
  end

  test "display error, when subscriber already exist", %{
    subscribers: subscribers,
    payload: payload
  } do
    result = Core.create_subscriber(subscribers, payload)
    {:error, "Subscriber `123` already exist"} = result
  end

  test "display error, when type does not exist", %{
    payload: payload
  } do
    payload = Map.put(payload, :type, :shausuha)
    result = Core.create_subscriber([], payload)
    {:error, "Only 'prepaid' or 'postpaid' are accepted"} = result
  end

  test "search a subscriber", %{
    subscribers: subscribers
  } do
    expect = %Subscriber{
      full_name: "Estevan",
      phone_number: "123",
      type: %Prepaid{credits: 0, recharges: []}
    }

    result = Core.search_subscriber(subscribers, "123")
    assert expect == result
  end

  test "return nil if subscriber does not exist", %{
    subscribers: subscribers
  } do
    result = Core.search_subscriber(subscribers, "198")
    assert result == nil
  end

  test "make a recharge", %{
    subscribers: subscribers
  } do
    date = ~D[2024-05-08]

    expected = [
      %Telephony.Core.Subscriber{
        full_name: "Estevan 2",
        phone_number: "1232",
        type: %Telephony.Core.Prepaid{credits: 1, recharges: []},
        calls: []
      },
      %Telephony.Core.Subscriber{
        full_name: "Estevan",
        phone_number: "123",
        type: %Telephony.Core.Prepaid{
          credits: 2,
          recharges: [%Telephony.Core.Recharge{value: 2, date: ~D[2024-05-08]}]
        },
        calls: []
      }
    ]

    result = Core.make_recharge(subscribers, "123", 2, date)

    assert result == expected
  end
end
