defmodule Monzo.Factory do
  use ExMachina

  def account_factory() do
    %Monzo.Account{
      created: "2015-10-30T23:00:00Z",
      description: "Tony Stark's Account",
      id: sequence(:id, &"id-#{&1}")
    }
  end

  def balance_factory() do
    %Monzo.Balance{
      balance: 5000,
      currency: "GBP",
      spend_today: 0
    }
  end

  def client_factory() do
    %Monzo.Client{
      access_token: sequence(:access_token, &"access-token-#{&1}"),
      client_id: sequence(:client_id, &"client-id-#{&1}"),
      expires_in: 120,
      refresh_token: sequence(:refresh_token, &"refresh-token-#{&1}"),
      token_type: "Bearer",
      user_id: sequence(:user_id, &"user-id-#{&1}")
    }
  end

  def feed_basic_item_factory() do
    %Monzo.Feed.BasicItem{
      background_color: 0xDC1405,
      body: "The arc reactor is costing you about 10m a day",
      body_color: 0xEFCE0B,
      image_url: "https://theavengers.com/jarvis.png",
      title: sequence(:title, &"Jarvis Monthly Report - #{&1}"),
      title_color: 0xFCFE05,
    }
  end

  def merchant_factory() do
    %Monzo.Merchant{
      address: nil,
      category: "shopping",
      created: "2015-10-30T10:00:00.000Z",
      emoji: "",
      group_id: sequence(:group_id, &"grp_#{&1}"),
      id: sequence(:id, &"merch_#{&1}"),
      logo: "https://theavengers.com/logo.png",
      name: "Avengers Ltd",
      online: true
    }
  end

  def address_factory() do
    %Monzo.Address{
      address: "85 Albert Embankment",
      approximate: false,
      city: "London",
      country: "GBR",
      formatted: "85 Albert Embankment, London SE1 7TP, United-Kingdom",
      latitude: "51.4873",
      longitude: "0.1243",
      postcode: "SE1 7TP",
      region: "Greater London",
      short_formatted: "85 Albert Embankment, London SE1 7TP",
      zoom_level: 10
    }
  end

  def transaction_factory() do
    %Monzo.Transaction{
      account_balance: 100000,
      amount: 50000,
      created: "2015-12-24T23:00:00Z",
      category: "transport",
      currency: "GBP",
      decline_reason: nil,
      description: "Iron Man armor",
      id: sequence(:id, &"tx_#{&1}"),
      merchant: sequence(:merchant, &"merch_#{&1}"),
      metadata: %{},
      notes: "Collector item",
      is_load: false,
      settled: true
    }
  end

  def webhook_factory() do
    %Monzo.Webhook{
      account_id: "acc_01",
      id: sequence(:id, &"webhook_#{&1}"),
      url: "https://theavengers.com/webhook",
    }
  end
end
