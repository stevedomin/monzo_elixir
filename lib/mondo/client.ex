defmodule Mondo.Client do
  @moduledoc """
  """

  defstruct access_token: nil, client_id: nil, client_secret: nil,
            expires_in: nil, refresh_token: nil, token_type: nil, user_id: nil

  @type t :: %__MODULE__{
    access_token: String.t,
    client_id: String.t,
    client_secret: String.t,
    expires_in: non_neg_integer(),
    refresh_token: String.t,
    token_type: String.t,
    user_id: String.t
  }

  @user_agent "mondo-elixir"

  def authenticate(client_id, client_secret, username, password) do
    req_body = %{
      grant_type: :password,
      client_id: client_id,
      client_secret: client_secret,
      username: username,
      password: password
    }

    with {:ok, body} <- post(nil, "oauth2/token", req_body),
         {:ok, client} <- Poison.decode(body, as: %Mondo.Client{}) do
      {:ok, %Mondo.Client{client | client_secret: client_secret}}
    end
  end

  def refresh(client) do
    req_body = %{
      grant_type: :refresh_token,
      client_id: client.client_id,
      client_secret: client.client_secret,
      refresh_token: client.refresh_token
    }

    with {:ok, body} <- post(nil, "oauth2/token", req_body),
         {:ok, new_client} <- Poison.decode(body, as: %Mondo.Client{}) do
      {:ok, %Mondo.Client{new_client | client_secret: client.client_secret}}
    end
  end

  def ping(client) do
    with {:ok, body} <- get(client, "ping/whoami"),
         {:ok, whoami} <- Poison.decode(body),
    do: {:ok, whoami}
  end

  def request(client, method, path, params \\ :empty, body \\ "", headers \\ []) do
    url = url(path, params)
    headers =
      headers
      |> put_headers_default
      |> put_headers_access_token(client)
      |> put_headers_for_method(method)
    body = prepare_body(body, method)

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

  defp put_headers_default(headers) do
    [{"User-Agent", "#{@user_agent}/#{Mondo.version}"} | headers]
  end

  defp put_headers_access_token(headers, nil), do: headers
  defp put_headers_access_token(headers, %{access_token: nil}), do: headers
  defp put_headers_access_token(headers, %{access_token: access_token}) do
    [{"Authorization", "Bearer #{access_token}"} | headers]
  end

  defp put_headers_for_method(headers, :post) do
    [{"Content-Type", "application/x-www-form-urlencoded; charset=utf-8"} | headers]
  end
  defp put_headers_for_method(headers, _), do: headers

  defp prepare_body(body, :post), do: Plug.Conn.Query.encode(body)
  defp prepare_body(body, _), do: body
end
