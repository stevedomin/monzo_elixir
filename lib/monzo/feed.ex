defmodule Monzo.Feed do
  @moduledoc """
  [Monzo API reference](https://monzo.com/docs/#feed)
  """

  @endpoint "feed"

  defmodule BasicItem do
    defstruct background_color: nil, body: nil, body_color: nil,
              image_url: nil, title: nil, title_color: nil

    @type t :: %__MODULE__{
      background_color: integer,
      body: String.t,
      body_color: integer,
      image_url: String.t,
      title: String.t,
      title_color: integer
    }
  end

  @doc """
  Create a basic feed item
  """
  @spec create(Monzo.Client.t, String.t, Monzo.Feed.BasicItem.t, String.t) :: :ok | {:error, Monzo.Error.t}
  def create(client, account_id, %Monzo.Feed.BasicItem{} = item, url) do
    req_body = %{
      account_id: account_id,
      type: :basic,
      params: Map.delete(item, :__struct__),
      url: url
    }
    case Monzo.Client.post(client, @endpoint, req_body) do
      {:ok, _body} -> :ok
      {:error, _reason} = err -> err
    end
  end
end
