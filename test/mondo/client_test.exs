defmodule Mondo.ClientTest do
  use ExUnit.Case
  import Mondo.Factory

  setup do
    bypass = Bypass.open
    Application.put_env(:mondo, :endpoint, "http://localhost:#{bypass.port}")
    client = build(:client)
    {:ok, bypass: bypass, client: client}
  end

  test "successful authentication", %{bypass: bypass, client: client} do
    Bypass.expect bypass, fn conn ->
      assert "/oauth2/token" == conn.request_path
      assert "POST" == conn.method
      Plug.Conn.resp(conn, 200, Poison.encode!(client))
    end
    assert {:ok, client} ==
           Mondo.Client.authenticate("client_id", "client_secret", "user", "pass")
  end

  test "failed auth" do
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
    assert {:ok, response} == Mondo.Client.ping(client)
  end

  test "ping with an unauthenticated client", %{bypass: bypass} do
    response = %{"authenticated" => false}
    Bypass.expect bypass, fn conn ->
      assert "/ping/whoami" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Poison.encode!(response))
    end
    assert {:ok, response} == Mondo.Client.ping(%Mondo.Client{})
  end
end
