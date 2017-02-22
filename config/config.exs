# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :wp_api_wrapper,
  ecto_repos: [WpApiWrapper.Repo]

# Configures the endpoint
config :wp_api_wrapper, WpApiWrapper.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "fVUa5HTMzoBFOvZixtWp9v5KICTWJ1qL5CTBtSv4SxmdwJaDFlc8PwyUe/baEpQ2",
  render_errors: [view: WpApiWrapper.ErrorView, accepts: ~w(html json)],
  pubsub: [name: WpApiWrapper.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
