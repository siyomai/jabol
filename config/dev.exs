import Config

# Configure your database
config :jabol, Jabol.Repo,
  database: "jabol_dev",
  hostname: "localhost",
  username: "postgres",
  password: "postgres",
  port: 5432,
  pool_size: 10