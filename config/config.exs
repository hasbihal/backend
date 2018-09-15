# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :hasbihal,
  ecto_repos: [Hasbihal.Repo]

# Configures the endpoint
config :hasbihal, HasbihalWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "EZUoyanlqqp+cVfhoNHcpUbflB98eqncfS1wx9n7wffz/shCJ/RgNQ5DUjtcb/8K",
  render_errors: [view: HasbihalWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Hasbihal.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
