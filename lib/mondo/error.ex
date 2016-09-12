defmodule Monzo.Error do
  @moduledoc """
  [Monzo API reference](https://monzo.com/docs/#errors)
  """

  defstruct code: nil, message: nil, params: nil

  @type t :: %__MODULE__{
    code: String.t,
    message: String.t,
    params: map()
  }
end
