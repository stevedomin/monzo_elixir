# Mondo Elixir

[![Build Status](https://travis-ci.org/stevedomin/mondo_elixir.svg?branch=master)](https://travis-ci.org/stevedomin/mondo_elixir)

An Elixir client for the [Mondo](https://getmondo.co.uk/) API.

## Installation

Add mondo to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:mondo, "~> 0.0.1"}]
end
```

## Usage

```elixir
iex> {:ok, client} = Mondo.Client.authenticate("client_id", "client_secret", "username", "password")
{:ok,
 %Mondo.Client{access_token: "access_token",
  client_id: "client_id", expires_in: 21600,
  refresh_token: "refresh_token",
  token_type: "Bearer", user_id: "user_id"}}

iex> {:ok, [account]} = Mondo.Account.list(client)
{:ok,
 [%Mondo.Account{created: "2008-05-02T19:00:00.000Z",
   description: "Tony Stark", id: "acc_01"}]}

iex> Mondo.Transaction.List(client, account.id)
{:ok,
 [%Mondo.Transaction{account_balance: 10000, amount: -5000, category: "entertainment",
   created: "2008-05-09T18:00:00Z", currency: "GBP", decline_reason: nil,
   description: "AVENGERS LTD", id: "tx_01",
   is_load: true, merchant: "merch_01", metadata: %{}, notes: "",
   settled: "2008-05-09T19:00:00Z"},
  %Mondo.Transaction{account_balance: 4000, amount: -1000, category: "cash",
   created: "2008-05-10T18:00:00Z", currency: "GBP", decline_reason: nil,
   description: "NEW AVENGERS",
   id: "tx_02", is_load: false,
   merchant: "merch_02", metadata: %{}, notes: "",
   settled: "2008-05-10Y19:00:00Z"},
```

## TODO

* Object expansion
* Pagination
* Attachments
* Annotate transaction
* Refresh token
* Better support for error code: 405, 406, 429, 500, 504

