## Changelog

## v0.2.0-dev
### Added
* Optionally expand merchant info when fetching transactions
* Add missing fields on Mondo.Transaction: attachments, local_amount, local_currency
* Add Mondo.refresh/1 for refreshing access token

### Changed
* Bump poison to 2.0.1
* Use Plug.Conn.Query module instead of URI to encode URL params

## v0.1.0

* Initial version
