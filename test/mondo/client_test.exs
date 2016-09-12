defmodule Monzo.ClientTest do
  use ExUnit.Case
  import Monzo.Factory

  setup do
    bypass = Bypass.open
    Application.put_env(:monzo, :endpoint, "http://localhost:#{bypass.port}")
    client = build(:client)
    {:ok, bypass: bypass, client: client}
  end

  test "successful authentication", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert "/oauth2/token" == conn.request_path
      assert "POST" == conn.method
      Plug.Conn.resp(conn, 200, Poison.encode!(%Monzo.Client{}))
    end
    assert {:ok, _client} =
           Monzo.Client.authenticate("client_id", "client_secret", "authorization_code")
  end

  test "failed auth" do
  end

  test "refresh token", %{bypass: bypass, client: client} do
    Bypass.expect bypass, fn conn ->
      assert "/oauth2/token" == conn.request_path
      assert "POST" == conn.method
      new_client = %Monzo.Client{client | access_token: "new_token"}
      Plug.Conn.resp(conn, 200, Poison.encode!(new_client))
    end
    assert {:ok, client} =
           Monzo.Client.refresh(client)
    assert client.access_token == "new_token"
  end

  test "ping with an authenticated client", %{bypass: bypass, client: client} do
    response = %{
      "authenticated" => true,
      "client_id" => client.client_id,
      "user_id" => client.user_id
    }
    Bypass.expect bypass, fn conn ->
      assert "/ping/whoami" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Poison.encode!(response))
    end
    assert {:ok, response} == Monzo.Client.ping(client)
  end

  test "ping with an unauthenticated client", %{bypass: bypass} do
    response = %{"authenticated" => false}
    Bypass.expect bypass, fn conn ->
      assert "/ping/whoami" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Poison.encode!(response))
    end
    assert {:ok, response} == Monzo.Client.ping(%Monzo.Client{})
  end
end
