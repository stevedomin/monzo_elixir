defmodule Monzo.Account do
  @moduledoc """
  [Monzo API reference](https://monzo.com/docs/#accounts)
  """

  @endpoint "accounts"

  defstruct created: nil, description: nil, id: nil

  @type t :: %__MODULE__{
    created: String.t,
    description: String.t,
    id: String.t
  }

  @doc """
  List accounts
  """
  @spec list(MonzoClient.t) :: {:ok, [t]} | {:error, Monzo.Error.t}
  def list(client) do
    with {:ok, body} <- Monzo.Client.get(client, @endpoint),
         {:ok, %{"accounts" => accounts}} <- Poison.decode(body, as: %{"accounts" => [%Monzo.Account{}]}),
    do: {:ok, accounts}
  end
end
