defmodule Monzo.Balance do
  @moduledoc """
  [Monzo API reference](https://monzo.com/docs/#balance)
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
  @spec get(Monzo.Client.t, String.t) :: {:ok, t} | {:error, Monzo.Error.t}
  def get(client, account_id) do
    with {:ok, body} <- Monzo.Client.get(client, @endpoint, %{"account_id" => account_id}),
         {:ok, balance} <- Poison.decode(body, as: %Monzo.Balance{}),
         do: {:ok, balance}
  end
end
