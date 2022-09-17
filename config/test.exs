import Config

# Configure your database
database_url = System.get_env("DATABASE_URL", "")

config :trip_planner, TripPlanner.Repo,
  url: String.replace(database_url, "?", "test"),
  database: "trip_planner_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :trip_planner, TripPlannerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "roPprPtNYSoN58bD6REUzjiqFek/EHfNbG8iBLu40CXBRx/skH5IwheF2kOu9bT8",
  server: false

# In test we don't send emails.
# config :trip_planner, TripPlanner.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
