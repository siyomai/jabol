import Config

# General application configuration
config :jabol, 
  repositories: [Jabol.Repo]

# Import environment specific config
import_config "#{config_env()}.exs"