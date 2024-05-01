defmodule Telephony.Core.SubscriberTest do
  use ExUnit.Case

  alias Telephony.Core.{Subscriber, Prepaid, Pospaid, Call, Recharge}

  setup do
    pospaid = %Subscriber{
      full_name: "Estevan",
      phone_number: "123",
      subscriber_type: %Pospaid{spent: 0}
    }

    prepaid = %Subscriber{
      full_name: "Estevan",
      phone_number: "123",
      subscriber_type: %Prepaid{credits: 7.2, recharges: []}
    }

    %{pospaid: pospaid, prepaid: prepaid}
  end

  test "create a prepaid subscriber" do
    # given
    payload = %{
      full_name: "Estevan",
      phone_number: "123",
      subscriber_type: :prepaid
    }

    # when
    result = Subscriber.new(payload)

    # then
    expected = %Subscriber{
      full_name: "Estevan",
      phone_number: "123",
      subscriber_type: %Prepaid{credits: 0, recharges: []}
    }

    assert result == expected
  end

  test "create a pospaid subscriber" do
    # given
    payload = %{
      full_name: "Estevan",
      phone_number: "123",
      subscriber_type: :pospaid
    }

    # when
    result = Subscriber.new(payload)

    # then
    expected = %Subscriber{
      full_name: "Estevan",
      phone_number: "123",
      subscriber_type: %Pospaid{spent: 0}
    }

    assert result == expected
  end

  test "make a pospaid call", %{pospaid: pospaid} do
    date = NaiveDateTime.utc_now()

    expected = %Subscriber{
      full_name: "Estevan",
      phone_number: "123",
      subscriber_type: %Pospaid{spent: 2.08},
      calls: [
        %Call{time_spent: 2, date: date}
      ]
    }

    result = Subscriber.make_call(pospaid, 2, date)

    assert result == expected
  end

  test "make a prepaid call", %{prepaid: prepaid} do
    time_spent = 2
    date = NaiveDateTime.utc_now()

    expected = %Subscriber{
      full_name: "Estevan",
      phone_number: "123",
      subscriber_type: %Prepaid{credits: 4.4, recharges: []},
      calls: [
        %Call{time_spent: 2, date: date}
      ]
    }

    result = Subscriber.make_call(prepaid, time_spent, date)

    assert result == expected
  end

  test "make a recharge", %{
    prepaid: prepaid
  } do
    value = 100
    date = NaiveDateTime.utc_now()
    result = Subscriber.make_recharge(prepaid, value, date)

    expected = %Subscriber{
      full_name: "Estevan",
      phone_number: "123",
      subscriber_type: %Prepaid{
        credits: 107.2,
        recharges: [
          %Recharge{value: 100, date: date}
        ]
      }
    }

    assert expected == result
  end

  test "should throw error while trying a recharge that is not prepaid", %{
    pospaid: pospaid
  } do
    value = 100
    date = NaiveDateTime.utc_now()
    result = Subscriber.make_recharge(pospaid, value, date)

    expected = {:error, "Only prepaid can make a recharge"}

    assert expected == result
  end
end
