defmodule Telephony.Core.PospaidTest do
  use ExUnit.Case

  alias Telephony.Core.{Subscriber, Pospaid, Call}

  setup do
    subscriber = %Subscriber{
      full_name: "Estevan",
      phone_number: "123",
      subscriber_type: %Pospaid{spent: 0}
    }

    %{subscriber: subscriber}
  end

  test "make a call", %{subscriber: subscriber} do
    time_spent = 2
    date = NaiveDateTime.utc_now()
    result = Pospaid.make_call(subscriber, time_spent, date)

    expected = %Subscriber{
      full_name: "Estevan",
      phone_number: "123",
      subscriber_type: %Pospaid{spent: 2.08},
      calls: [
        %Call{time_spent: 2, date: date}
      ]
    }

    assert expected == result
  end
end
