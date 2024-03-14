defmodule Telephony.Core.Pospaid do
  defstruct spent: 0

  def new(payload) do
    struct(__MODULE__, payload)
  end
end
