## Changelog

## v0.2.0 - 2016-06-25
### Added
* Optionally expand merchant info when fetching transactions
* Add missing fields on Mondo.Transaction: attachments, local_amount, local_currency
* Add Mondo.refresh/1 for refreshing access token

### Changed
* Use Plug.Conn.Query module instead of URI to encode URL params
* Bump poison to 2.2

### Removed
* Remove `Mondo.Client.authenticate/4` in favor of `Mondo.Client.authenticate/3`. Mondo has dropped support for
username/password auth from their API.

## v0.1.0

* Initial version
