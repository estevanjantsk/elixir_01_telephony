# Telephony

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `telephony` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:telephony, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/telephony>.

alias Telephony.Server
{:ok, pid} = Server.start_link :telephony

GenServer.call pid, {:create_subscriber, %{full_name: "Estevan", phone_number: "123", type: :prepaid}}

:sys.get_state pid