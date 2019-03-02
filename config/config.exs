# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :g404, G404Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "oKRs2UhWbfd7cd6QZnSj6tBBDCambvMajKjKPbmrOPCqn4Y6jWJ70f8m8bpTa4C6",
  render_errors: [view: G404Web.ErrorView],
  pubsub: [name: G404.PubSub, adapter: Phoenix.PubSub.PG2]

config :g404, G404.YandexTranslate,
  token: "trnsl.1.1.20190302T094812Z.341d21fa6dd01e81.507a29200da3aac837b262d9b0dbcfe61de68588"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
