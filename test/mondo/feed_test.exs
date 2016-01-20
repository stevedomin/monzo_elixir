defmodule Mondo.FeedTest do
  use ExUnit.Case
  import Mondo.Factory

  alias Mondo.Feed

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

  test "create a basic feed item", %{bypass: bypass, client: client} do
    account = build(:account)
    basic_item = build(:feed_basic_item)
    url = "https://theavengers.com/monthly"
    Bypass.expect bypass, fn conn ->
      conn = parse(conn)
      expected_body_params = %{
        "account_id" => account.id,
        "params" => %{
          "background_color" => to_string(basic_item.background_color),
          "body" => basic_item.body,
          "body_color" => to_string(basic_item.body_color),
          "image_url" => basic_item.image_url,
          "title" => basic_item.title,
          "title_color" => to_string(basic_item.title_color)
        },
        "type" => "basic",
        "url" => url
      }
      assert expected_body_params == conn.body_params
      assert "/feed" == conn.request_path
      assert "POST" == conn.method
      Plug.Conn.resp(conn, 200, "{}")
    end
    assert :ok == Feed.create(client, account.id, basic_item, url)
  end
end
