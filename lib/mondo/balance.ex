defmodule Mondo.Balance do
  @moduledoc """
  [Mondo API reference](https://getmondo.co.uk/docs/#balance)
  """

  @endpoint "balance"

  defstruct balance: nil, currency: nil, spend_today: nil

  @type t :: %__MODULE__{
    balance: integer,
    currency: String.t,
    spend_today: integer
  }

  @doc """
  Get balance
  """
  @spec get(Mondo.Client.t, String.t) :: {:ok, t} | {:error, Mondo.Error.t}
  def get(client, account_id) do
    with {:ok, body} <- Mondo.Client.get(client, @endpoint, %{"account_id" => account_id}),
         {:ok, balance} <- Poison.decode(body, as: %Mondo.Balance{}),
         do: {:ok, balance}
  end
end
