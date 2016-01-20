defmodule Mondo.Account do
  @moduledoc """
  [Mondo API reference](https://getmondo.co.uk/docs/#accounts)
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
  @spec list(MondoClient.t) :: {:ok, [t]} | {:error, Mondo.Error.t}
  def list(client) do
    with {:ok, body} <- Mondo.Client.get(client, @endpoint),
         {:ok, %{"accounts" => accounts}} <- Poison.decode(body, as: %{"accounts" => [%Mondo.Account{}]}),
    do: {:ok, accounts}
  end
end
