import Config

config :my_app,
  environment: config_env()

import_config "#{config_env()}.exs"
