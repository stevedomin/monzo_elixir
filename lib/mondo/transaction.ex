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
    # merchant: String.t | Merchant.t,
    metadata: map,
    notes: String.t,
    is_load: boolean,
    settled: boolean
  }

  @doc """
  List transactions
  """
  @spec list(Mondo.Client.t, String.t) :: {:ok, [Mondo.Transaction.t]} | {:error, Mondo.Error.t}
  def list(client, account_id) do
    with {:ok, body} <- Mondo.Client.get(client, @endpoint, %{"account_id" => account_id}),
         {:ok, %{"transactions" => transactions}} <- Poison.decode(body, as: %{"transactions" => [%Mondo.Transaction{}]}),
    do: {:ok, transactions}
  end

  @doc """
  Get a transaction
  """
  @spec get(Mondo.Client.t, String.t) :: {:ok, Mondo.Transaction.t} | {:error, Mondo.Error.t}
  def get(client, transaction_id) do
    with {:ok, body} <- Mondo.Client.get(client, @endpoint <> "/" <> transaction_id),
         {:ok, %{"transaction" => transaction}} <- Poison.decode(body, as: %{"transaction" => %Mondo.Transaction{}}),
    do: {:ok, transaction}
  end
end
