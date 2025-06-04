import Config

# Configure your database
config :jabol, Jabol.Repo,
  database: "jabol_prod",
  pool_size: 15,
  ssl: true

# Don't print debug messages in production
config :logger, level: :info
