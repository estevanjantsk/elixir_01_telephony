defmodule Telephony.Core.PospaidTest do
  use ExUnit.Case

  alias Telephony.Core.{Subscriber, Pospaid, Call, Invoice}

  setup do
    subscriber = %Subscriber{
      full_name: "Estevan",
      phone_number: "123",
      type: %Pospaid{spent: 0}
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
      type: %Pospaid{spent: 2.08},
      calls: [
        %Call{time_spent: 2, date: date}
      ]
    }

    assert expected == result
  end

  test "print invoice" do
    date = NaiveDateTime.utc_now()

    subscriber = %Subscriber{
      full_name: "Estevan",
      phone_number: "123",
      type: %Pospaid{
        spent: 100
      },
      calls: [
        %Call{
          date: date,
          time_spent: 10
        },
        %Call{
          date: ~D[2024-07-02],
          time_spent: 10
        }
      ]
    }

    type = subscriber.type
    calls = subscriber.calls

    assert Invoice.print(
             type,
             calls,
             2024,
             7
           ) == %{
             calls: [
               %{
                 date: ~D[2024-07-02],
                 time_spent: 10,
                 value_spent: 10.4
               }
             ],
             spent: 100
           }
  end
end
