defmodule Mondo.BalanceTest do
  use ExUnit.Case
  import Mondo.Factory

  alias Mondo.Balance

  setup_all do
    bypass = Bypass.open
    Application.put_env(:mondo, :endpoint, "http://localhost:#{bypass.port}")
    client = build(:client)
    {:ok, bypass: bypass, client: client}
  end

  test "get balance for a valid account", %{bypass: bypass, client: client} do
    balance = build(:balance)
    account = build(:account)
    Bypass.expect bypass, fn conn ->
      conn = Plug.Conn.fetch_query_params(conn)
      assert "/balance" == conn.request_path
      assert %{"account_id" => account.id} == conn.query_params
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Poison.encode!(balance))
    end
    assert Balance.get(client, account.id) == {:ok, balance}
  end

  test "get balance for an inexistent account", %{bypass: bypass, client: client} do
    Bypass.expect bypass, fn conn ->
      conn = Plug.Conn.fetch_query_params(conn)
      assert %{"account_id" => "123"} == conn.query_params
      assert "/balance" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 403, "{}")
    end
    assert {:error, _reason} = Balance.get(client, "123")
  end
end
