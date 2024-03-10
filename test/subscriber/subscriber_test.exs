defmodule Subscriber.SubscriberTest do
  use ExUnit.Case

  alias Subscriber.Subscriber

  test "create a subscriber" do
    # given
    payload = %{
      full_name: "Estevan"
    }

    # when
    result = Subscriber.new(payload)

    # then
    expected = %Subscriber{
      full_name: "Estevan"
    }

    assert result == expected
  end
end
