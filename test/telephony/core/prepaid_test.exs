defmodule Telephony.Core.PrepaidTest do
  use ExUnit.Case

  alias Telephony.Core.{Subscriber, Prepaid, Call, Recharge}

  setup do
    subscriber = %Subscriber{
      full_name: "Estevan",
      phone_number: "123",
      subscriber_type: %Prepaid{credits: 10, recharges: []}
    }

    subscriber_without_credits = %Subscriber{
      full_name: "Estevan",
      phone_number: "123",
      subscriber_type: %Prepaid{credits: 0, recharges: []}
    }

    %{subscriber: subscriber, subscriber_without_credits: subscriber_without_credits}
  end

  test "make a call", %{subscriber: subscriber} do
    time_spent = 2
    date = NaiveDateTime.utc_now()
    result = Prepaid.make_call(subscriber, time_spent, date)

    expected = %Subscriber{
      full_name: "Estevan",
      phone_number: "123",
      subscriber_type: %Prepaid{credits: 7.2, recharges: []},
      calls: [
        %Call{time_spent: 2, date: date}
      ]
    }

    assert expected == result
  end

  test "make a call when user does not have credits", %{
    subscriber_without_credits: subscriber_without_credits
  } do
    time_spent = 2
    date = NaiveDateTime.utc_now()
    result = Prepaid.make_call(subscriber_without_credits, time_spent, date)

    expected = {:error, "Subscriber does not have credits"}

    assert expected == result
  end

  test "make a recharge", %{
    subscriber: subscriber
  } do
    value = 100
    date = NaiveDateTime.utc_now()
    result = Prepaid.make_recharge(subscriber, value, date)

    expected = %Subscriber{
      full_name: "Estevan",
      phone_number: "123",
      subscriber_type: %Prepaid{
        credits: 110,
        recharges: [
          %Recharge{value: 100, date: date}
        ]
      }
    }

    assert expected == result
  end
end
