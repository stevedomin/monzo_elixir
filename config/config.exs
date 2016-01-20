use Mix.Config

config :mondo, endpoint: "https://production-api.gmon.io"

import_config "#{Mix.env}.exs"
