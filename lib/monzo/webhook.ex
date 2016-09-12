defmodule Monzo.Webhook do
  @moduledoc """
  [Monzo API reference](https://monzo.com/docs/#webhooks)
  """

  @endpoint "webhooks"

  defstruct account_id: nil, id: nil, url: nil

  @type t :: %__MODULE__{
    account_id: String.t,
    id: String.t,
    url: String.t
  }

  @doc """
  List all web hooks registered on an account
  """
  @spec list(Monzo.Client.t, String.t) :: {:ok, [Monzo.Webhook.t]} | {:error, Monzo.Error.t}
  def list(client, account_id) do
    with {:ok, body} <- Monzo.Client.get(client, @endpoint, %{"account_id" => account_id}),
         {:ok, %{"webhooks" => webhooks}} <- Poison.decode(body, as: %{"webhooks" => [%Monzo.Webhook{}]}),
    do: {:ok, webhooks}
  end

  @doc """
  Register a web hook
  """
  @spec register(Monzo.Client.t, String.t, String.t) :: {:ok, Monzo.Webhook.t} | {:error, Monzo.Error.t}
  def register(client, account_id, url) do
    req_body = %{
      account_id: account_id,
      url: url
    }
    with {:ok, body} <- Monzo.Client.post(client, @endpoint, req_body),
         {:ok, %{"webhook" => webhook}} <- Poison.decode(body, as: %{"webhook" => %Monzo.Webhook{}}),
    do: {:ok, webhook}
  end

  @doc """
  Delete a webhook
  """
  @spec delete(Monzo.Client.t, String.t) :: :ok | {:error, Monzo.Error.t}
  def delete(client, webhook_id) do
    case Monzo.Client.delete(client, @endpoint <> "/" <> webhook_id) do
      {:ok, _body} -> :ok
      {:error, _reason} = err -> err
    end
  end
end
