defmodule Mondo.Error do
  @moduledoc """
  [Mondo API reference](https://getmondo.co.uk/docs/#errors)
  """

  defstruct code: nil, message: nil, params: nil

  @type t :: %__MODULE__{
    code: String.t,
    message: String.t,
    params: map()
  }
end
