import Config

# Configure your database
config :jabol, Jabol.Repo,
  database: "jabol_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox