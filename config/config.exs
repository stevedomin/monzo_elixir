use Mix.Config

config :monzo, endpoint: "https://api.monzo.com"

import_config "#{Mix.env}.exs"
