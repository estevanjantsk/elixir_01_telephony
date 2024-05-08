defmodule Telephony.ServerTest do
  use ExUnit.Case

  alias Telephony.Server
  alias Telephony.Core.{Subscriber, Prepaid}

  setup do
    {:ok, pid} = Server.start_link(:test)
    %{pid: pid, process_name: :test}
  end

  test "check telephony subscribers state", %{pid: pid} do
    assert [] == :sys.get_state(pid)
  end

  test "create a subscriber", %{pid: pid, process_name: process_name} do
    payload = %{
      full_name: "Estevan",
      type: :prepaid,
      phone_number: "123"
    }

    expect = [
      %Subscriber{
        full_name: "Estevan",
        phone_number: "123",
        type: %Prepaid{credits: 0, recharges: []},
        calls: []
      }
    ]

    assert [] == :sys.get_state(pid)

    result = GenServer.call(process_name, {:create_subscriber, payload})

    assert expect == result
  end

  test "error while trying to add same subscriber", %{process_name: process_name} do
    payload = %{
      full_name: "Estevan",
      type: :prepaid,
      phone_number: "123"
    }

    expect = {:error, "Subscriber `123` already exist"}

    GenServer.call(process_name, {:create_subscriber, payload})

    result = GenServer.call(process_name, {:create_subscriber, payload})

    assert expect == result
  end

  test "search subscriber", %{process_name: process_name} do
    subscriber = %{
      full_name: "Estevan",
      type: :prepaid,
      phone_number: "123"
    }

    payload = "123"

    expect = %Subscriber{
      full_name: "Estevan",
      phone_number: "123",
      type: %Prepaid{credits: 0, recharges: []},
      calls: []
    }

    GenServer.call(process_name, {:create_subscriber, subscriber})

    result = GenServer.call(process_name, {:search_subscriber, payload})

    assert expect == result
  end
end
