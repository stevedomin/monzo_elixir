defmodule Monzo.Transaction do
  @moduledoc """
  [Monzo API reference](https://monzo.com/docs/#transactions)
  """

  @endpoint "transactions"

  defstruct account_balance: nil, amount: nil, attachments: nil, category: nil,
            created: nil, currency: nil, decline_reason: nil, description: nil,
            id: nil, is_load: nil, local_amount: nil, local_currency: nil,
            merchant: nil, metadata: nil, notes: nil, settled: nil

  @type t :: %__MODULE__{
    account_balance: integer,
    amount: integer,
    attachments: list,
    category: String.t,
    created: String.t,
    currency: String.t,
    decline_reason: String.t,
    description: String.t,
    id: String.t,
    is_load: boolean,
    local_amount: String.t,
    local_currency: String.t,
    merchant: Monzo.Merchant.t,
    metadata: map,
    notes: String.t,
    settled: boolean
  }

  @doc """
  List transactions
  """
  @spec list(Monzo.Client.t, String.t) :: {:ok, [Monzo.Transaction.t]} | {:error, Monzo.Error.t}
  def list(client, account_id, opts \\ []) do
    {params, as} = Keyword.get(opts, :merchant, false) |> with_merchant(%{"account_id" => account_id})
    with {:ok, body} <- Monzo.Client.get(client, @endpoint, params),
         {:ok, %{"transactions" => transactions}} <- Poison.decode(body, as: %{"transactions" => [as]}),
    do: {:ok, transactions}
  end

  @doc """
  Get a transaction
  """
  @spec get(Monzo.Client.t, String.t) :: {:ok, Monzo.Transaction.t} | {:error, Monzo.Error.t}
  def get(client, transaction_id, opts \\ []) do
    {params, as} = Keyword.get(opts, :merchant, false) |> with_merchant(%{})

    with {:ok, body} <- Monzo.Client.get(client, @endpoint <> "/" <> transaction_id, params),
         {:ok, %{"transaction" => transaction}} <- Poison.decode(body, as: %{"transaction" => as}),
    do: {:ok, transaction}
  end

  @doc false
  @spec with_merchant(boolean, map) :: {map, Monzo.Transaction.t}
  defp with_merchant(true, params) do
    params = Map.put(params, :expand, ["merchant"])
    as = %Monzo.Transaction{merchant: %Monzo.Merchant{address: %Monzo.Address{}}}
    {params, as}
  end
  defp with_merchant(_, params) do
    as = %Monzo.Transaction{}
    {params, as}
  end
end

