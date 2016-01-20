defmodule Mondo.Feed do
  @moduledoc """
  [Mondo API reference](https://getmondo.co.uk/docs/#feed)
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
  @spec create(Mondo.Client.t, String.t, Mondo.Feed.BasicItem.t, String.t) :: :ok | {:error, Mondo.Error.t}
  def create(client, account_id, %Mondo.Feed.BasicItem{} = item, url) do
    req_body = %{
      account_id: account_id,
      type: :basic,
      params: Map.delete(item, :__struct__),
      url: url
    }
    case Mondo.Client.post(client, @endpoint, req_body) do
      {:ok, _body} -> :ok
      {:error, _reason} = err -> err
    end
  end
end
