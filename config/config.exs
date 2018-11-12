# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :hasbihal,
  ecto_repos: [Hasbihal.Repo]

# Configures the endpoint
config :hasbihal, HasbihalWeb.Endpoint,
  url: [host: "localhost"],
  http: [ip: {0, 0, 0, 0}, port: 4000],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  render_errors: [view: HasbihalWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Hasbihal.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :hasbihal, Hasbihal.Guardian,
  allowed_algos: ["HS512"],
  issuer: "hasbihal",
  verify_issuer: true,
  secret_key: System.get_env("SECRET_KEY_BASE")

config :hasbihal, Hasbihal.Mailer,
  adapter: Bamboo.SMTPAdapter,
  hostname: System.get_env("SMTP_HOSTNAME"),
  server: System.get_env("SMTP_SERVER"),
  port: System.get_env("SMTP_PORT"),
  username: System.get_env("SMTP_USERNAME"),
  password: System.get_env("SMTP_PASSWORD"),
  tls: :if_available,
  ssl: false,
  retries: 1

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
