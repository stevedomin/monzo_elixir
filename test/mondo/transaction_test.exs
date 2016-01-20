defmodule Mondo.TransactionTest do
  use ExUnit.Case
  import Mondo.Factory

  alias Mondo.Transaction

  setup_all do
    bypass = Bypass.open
    Application.put_env(:mondo, :endpoint, "http://localhost:#{bypass.port}")
    client = build(:client)
    {:ok, bypass: bypass, client: client}
  end

  test "list transactions with a valid account", %{bypass: bypass, client: client} do
    transactions = build_list(3, :transaction)
    account = build(:account)
    Bypass.expect bypass, fn conn ->
      conn = Plug.Conn.fetch_query_params(conn)
      assert "/transactions" == conn.request_path
      assert %{"account_id" => account.id} == conn.query_params
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Poison.encode!(%{"transactions" => transactions}))
    end
    assert Transaction.list(client, account.id) == {:ok, transactions}
  end

  test "list transactions with an invalid account", %{bypass: bypass, client: client} do
     Bypass.expect bypass, fn conn ->
      conn = Plug.Conn.fetch_query_params(conn)
      assert "/transactions" == conn.request_path
      assert %{"account_id" => "123"} == conn.query_params
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 403, "{}")
    end
    assert {:error, _reason} = Transaction.list(client, "123")
  end

  test "get an existing transaction", %{bypass: bypass, client: client} do
    transaction = build(:transaction)
    Bypass.expect bypass, fn conn ->
      assert "/transactions/#{transaction.id}" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Poison.encode!(%{"transaction" => transaction}))
    end
    assert Transaction.get(client, transaction.id) == {:ok, transaction}
  end

  test "get a non-existing transaction", %{bypass: bypass, client: client} do
    Bypass.expect bypass, fn conn ->
      assert "/transactions/123" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 404, "{}")
    end
    assert {:error, _reason} = Transaction.get(client, "123")
  end
end
