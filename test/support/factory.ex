defmodule Mondo.Factory do
  use ExMachina

  def factory(:account) do
    %Mondo.Account{
      created: "2015-10-30T23:00:00Z",
      description: "Tony Stark's Account",
      id: sequence(:id, &"id-#{&1}")
    }
  end

  def factory(:balance) do
    %Mondo.Balance{
      balance: 5000,
      currency: "GBP",
      spend_today: 0
    }
  end

  def factory(:client) do
    %Mondo.Client{
      access_token: sequence(:access_token, &"access-token-#{&1}"),
      client_id: sequence(:client_id, &"client-id-#{&1}"),
      expires_in: 120,
      refresh_token: sequence(:refresh_token, &"refresh-token-#{&1}"),
      token_type: "Bearer",
      user_id: sequence(:user_id, &"user-id-#{&1}")
    }
  end

  def factory(:feed_basic_item) do
    %Mondo.Feed.BasicItem{
      background_color: 0xDC1405,
      body: "The arc reactor is costing you about 10m a day",
      body_color: 0xEFCE0B,
      image_url: "https://theavengers.com/jarvis.png",
      title: sequence(:title, &"Jarvis Monthly Report - #{&1}"),
      title_color: 0xFCFE05,
    }
  end

  def factory(:transaction) do
    %Mondo.Transaction{
      account_balance: 100000,
      amount: 50000,
      created: "2015-12-24T23:00:00Z",
      category: "transport",
      currency: "GBP",
      decline_reason: nil,
      description: "Iron Man armor",
      id: sequence(:id, &"tx_#{&1}"),
      merchant: nil,
      metadata: %{},
      notes: "Collector item",
      is_load: false,
      settled: true
    }
  end

  def factory(:webhook) do
    %Mondo.Webhook{
      account_id: "acc_01",
      id: sequence(:id, &"webhook_#{&1}"),
      url: "https://theavengers.com/webhook",
    }
  end
end
