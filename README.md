# Monzo Elixir

[![Build Status](https://travis-ci.org/stevedomin/monzo_elixir.svg?branch=master)](https://travis-ci.org/stevedomin/monzo_elixir)

An Elixir client for the [Monzo](https://getmonzo.co.uk/) API.

## Installation

Add monzo to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:monzo, "~> 0.2.0"}]
end
```

## Usage

```elixir
iex> {:ok, client} = Monzo.Client.authenticate("client_id", "client_secret", "authorization_code")
{:ok,
 %Monzo.Client{access_token: "access_token",
  client_id: "client_id", expires_in: 21600,
  refresh_token: "refresh_token",
  token_type: "Bearer", user_id: "user_id"}}

iex> {:ok, [account]} = Monzo.Account.list(client)
{:ok,
 [%Monzo.Account{created: "2008-05-02T19:00:00.000Z",
   description: "Tony Stark", id: "acc_01"}]}

iex> Monzo.Transaction.List(client, account.id)
{:ok,
 [%Monzo.Transaction{account_balance: 10000, amount: -5000, category: "entertainment",
   created: "2008-05-09T18:00:00Z", currency: "GBP", decline_reason: nil,
   description: "AVENGERS LTD", id: "tx_01",
   is_load: true, merchant: "merch_01", metadata: %{}, notes: "",
   settled: "2008-05-09T19:00:00Z"},
  %Monzo.Transaction{account_balance: 4000, amount: -1000, category: "cash",
   created: "2008-05-10T18:00:00Z", currency: "GBP", decline_reason: nil,
   description: "NEW AVENGERS",
   id: "tx_02", is_load: false,
   merchant: "merch_02", metadata: %{}, notes: "",
   settled: "2008-05-10Y19:00:00Z"},
```

## TODO

* Pagination
* Attachments
* Annotate transaction
* Better support for error code: 405, 406, 429, 500, 504

## LICENSE

See [LICENSE](https://github.com/stevedomin/monzo_elixir/blob/master/LICENSE)

