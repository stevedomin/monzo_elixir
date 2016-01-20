defmodule Mondo.WebhookTest do
  use ExUnit.Case
  import Mondo.Factory

  alias Mondo.Webhook

  def parse(conn, opts \\ []) do
    opts = Keyword.put_new(opts, :parsers, [Plug.Parsers.URLENCODED])
    Plug.Parsers.call(conn, Plug.Parsers.init(opts))
  end

  setup_all do
    bypass = Bypass.open
    Application.put_env(:mondo, :endpoint, "http://localhost:#{bypass.port}")
    client = build(:client)
    {:ok, bypass: bypass, client: client}
  end

  test "list webhooks for a valid account", %{bypass: bypass, client: client} do
    webhooks = build_list(3, :webhook)
    account = build(:account)
    Bypass.expect bypass, fn conn ->
      conn = Plug.Conn.fetch_query_params(conn)
      assert "/webhooks" == conn.request_path
      assert %{"account_id" => account.id} == conn.query_params
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 200, Poison.encode!(%{"webhooks" => webhooks}))
    end
    assert Webhook.list(client, account.id) == {:ok, webhooks}
  end

  test "list webhooks for an inexistent account", %{bypass: bypass, client: client} do
    Bypass.expect bypass, fn conn ->
      conn = Plug.Conn.fetch_query_params(conn)
      assert "/webhooks" == conn.request_path
      assert %{"account_id" => "123"} == conn.query_params
      assert "GET" == conn.method
      Plug.Conn.resp(conn, 403, Poison.encode!("{}"))
    end
    assert {:error, _reason} = Webhook.list(client, "123")
  end

  test "register webhook for a valid account", %{bypass: bypass, client: client} do
    webhook = build(:webhook)
    account = build(:account)
    Bypass.expect bypass, fn conn ->
      conn = parse(conn)
      assert "/webhooks" == conn.request_path
      expected_body_params = %{
        "account_id" => account.id,
        "url" => webhook.url
      }
      assert expected_body_params == conn.body_params
      assert "POST" == conn.method
      Plug.Conn.resp(conn, 200, Poison.encode!(%{"webhook" => webhook}))
    end
    assert Webhook.register(client, account.id, webhook.url) == {:ok, webhook}
  end

  test "register webhook for an inexistent account", %{bypass: bypass, client: client} do
    Bypass.expect bypass, fn conn ->
      conn = parse(conn)
      assert "/webhooks" == conn.request_path
      expected_body_params = %{
        "account_id" => "123",
        "url" => ""
      }
      assert expected_body_params == conn.body_params
      assert "POST" == conn.method
      Plug.Conn.resp(conn, 403, Poison.encode!("{}"))
    end
    assert {:error, _reason} = Webhook.register(client, "123", "")
  end

  test "delete an existing webhook", %{bypass: bypass, client: client} do
    webhook = build(:webhook)
    Bypass.expect bypass, fn conn ->
      assert "/webhooks/#{webhook.id}" == conn.request_path
      assert "DELETE" == conn.method
      Plug.Conn.resp(conn, 200, "{}")
    end
    assert Webhook.delete(client, webhook.id) == :ok
  end

  test "delete an inexistent webhook", %{bypass: bypass, client: client} do
    Bypass.expect bypass, fn conn ->
      assert "/webhooks/123" == conn.request_path
      assert "DELETE" == conn.method
      Plug.Conn.resp(conn, 404, "{}")
    end
    assert {:error, _reason} = Webhook.delete(client, "123")
  end
end
