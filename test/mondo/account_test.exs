defmodule Mondo.AccountTest do
  use ExUnit.Case
  import Mondo.Factory

  alias Mondo.Account

  setup_all do
    bypass = Bypass.open
    Application.put_env(:mondo, :endpoint, "http://localhost:#{bypass.port}")
    client = build(:client)
    {:ok, bypass: bypass, client: client}
  end

  test "list accounts", %{bypass: bypass, client: client} do
    accounts = build_list(3, :account)
    Bypass.expect bypass, fn conn ->
      assert "/accounts" == conn.request_path
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Poison.encode!(%{"accounts" => accounts}))
    end
    assert Account.list(client) == {:ok, accounts}
  end
end
