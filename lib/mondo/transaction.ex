defmodule Mondo.Transaction do
  @moduledoc """
  [Mondo API reference](https://getmondo.co.uk/docs/#transactions)
  """

  @endpoint "transactions"

  defstruct account_balance: nil, amount: nil, category: nil, created: nil,
            currency: nil, decline_reason: nil, description: nil, id: nil,
            merchant: nil, metadata: nil, notes: nil, is_load: nil, settled: nil

  @type t :: %__MODULE__{
    account_balance: integer,
    amount: integer,
    category: String.t,
    created: String.t,
    currency: String.t,
    decline_reason: String.t,
    description: String.t,
    id: String.t,
    merchant: Mondo.Merchant.t,
    metadata: map,
    notes: String.t,
    is_load: boolean,
    settled: boolean
  }

  @doc """
  List transactions
  """
  @spec list(Mondo.Client.t, String.t) :: {:ok, [Mondo.Transaction.t]} | {:error, Mondo.Error.t}
  def list(client, account_id, opts \\ []) do
    {params, as} = Keyword.get(opts, :merchant, false) |> with_merchant(%{"account_id" => account_id})
    with {:ok, body} <- Mondo.Client.get(client, @endpoint, params),
         {:ok, %{"transactions" => transactions}} <- Poison.decode(body, as: %{"transactions" => [as]}),
    do: {:ok, transactions}
  end

  @doc """
  Get a transaction
  """
  @spec get(Mondo.Client.t, String.t) :: {:ok, Mondo.Transaction.t} | {:error, Mondo.Error.t}
  def get(client, transaction_id, opts \\ []) do
    {params, as} = Keyword.get(opts, :merchant, false) |> with_merchant(%{})

    with {:ok, body} <- Mondo.Client.get(client, @endpoint <> "/" <> transaction_id, params),
         {:ok, %{"transaction" => transaction}} <- Poison.decode(body, as: %{"transaction" => as}),
    do: {:ok, transaction}
  end

  @doc false
  @spec with_merchant(boolean, map) :: {map, Mondo.Transaction.t}
  defp with_merchant(true, params) do
    params = Map.put(params, :expand, ["merchant"])
    as = %Mondo.Transaction{merchant: %Mondo.Merchant{address: %Mondo.Address{}}}
    {params, as}
  end
  defp with_merchant(_, params) do
    as = %Mondo.Transaction{}
    {params, as}
  end
end

