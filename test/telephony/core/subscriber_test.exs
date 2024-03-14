defmodule Telephony.Core.SubscriberTest do
  use ExUnit.Case

  alias Telephony.Core.{Subscriber, Prepaid, Pospaid}

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
end
