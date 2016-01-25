defmodule Mondo.Client do
  @moduledoc """
  """

  defstruct access_token: nil, client_id: nil, expires_in: nil,
            refresh_token: nil, token_type: nil, user_id: nil

  @type t :: %__MODULE__{
    access_token: String.t,
    client_id: String.t,
    expires_in: non_neg_integer(),
    refresh_token: String.t,
    token_type: String.t,
    user_id: String.t
  }

  @user_agent "mondo-elixir"

  def authenticate(client_id, client_secret, username, password) do
    req_body = %{
      grant_type: "password",
      client_id: client_id,
      client_secret: client_secret,
      username: username,
      password: password
    }

    with {:ok, body} <- post(nil, "oauth2/token", req_body),
         {:ok, client} <- Poison.decode(body, as: %Mondo.Client{}),
    do: {:ok, client}
  end

  def ping(client) do
    with {:ok, body} <- get(client, "ping/whoami"),
         {:ok, whoami} <- Poison.decode(body),
    do: {:ok, whoami}
  end

  def request(client, method, path, params \\ :empty, body \\ "", headers \\ []) do
    url = url(path, params)

    headers = [{"User-Agent", "#{@user_agent}/#{Mondo.version}"}] ++ headers

    if client && client.access_token do
      headers = [{"Authorization", "Bearer #{client.access_token}"}] ++ headers
    end

    if method == :post do
      headers = [{"Content-Type", "application/x-www-form-urlencoded; charset=utf-8"}] ++ headers
      body = Plug.Conn.Query.encode(body)
    end

    case HTTPoison.request(method, url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 400, body: body}} ->
        IO.inspect body
      {:ok, %HTTPoison.Response{status_code: 401, body: body}} ->
        {:error, Poison.decode!(body, as: Mondo.Error)}
      {:ok, %HTTPoison.Response{status_code: 403, body: body}} ->
        {:error, Poison.decode!(body, as: Mondo.Error)}
      {:ok, %HTTPoison.Response{status_code: 404, body: body}} ->
        {:error, Poison.decode!(body, as: Mondo.Error)}
      {:ok, _response} = resp -> resp
      {:error, %HTTPoison.Error{} = err} -> err
    end
  end

  def get(client, path, params \\ :empty) do
    request(client, :get, path, params)
  end

  def post(client, path, body, params \\ :empty) do
    request(client, :post, path, params, body)
  end

  def delete(client, path, params \\ :empty) do
    request(client, :delete, path, params)
  end

  def url(path, :empty), do: "#{Application.get_env(:mondo, :endpoint)}/#{path}"
  def url(path, params) do
    uri =
      url(path, :empty)
      |> URI.parse
      |> Map.put(:query, Plug.Conn.Query.encode(params))
    URI.to_string(uri)
  end
end
