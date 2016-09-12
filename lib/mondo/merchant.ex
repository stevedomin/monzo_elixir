defmodule Monzo.Merchant do
  defstruct address: nil, category: nil, created: nil, emoji: nil, group_id: nil,
            id: nil, logo: nil, name: nil, online: nil

  @type t :: %__MODULE__{
    address: Monzo.Address.t,
    category: String.t,
    created: String.t,
    emoji: String.t,
    group_id: String.t,
    id: String.t,
    logo: String.t,
    name: String.t,
    online: boolean
  }
end

