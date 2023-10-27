# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :accountant,
  ecto_repos: [Accountant.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

# Configures the endpoint
config :accountant, AccountantWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [html: AccountantWeb.ErrorHTML, json: AccountantWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Accountant.PubSub,
  live_view: [signing_salt: "gGFV9V/K"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :accountant, Accountant.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :money,
  # this allows you to do Money.new(100)
  default_currency: :EUR,
  # change the default thousands separator for Money.to_string
  separator: ".",
  # change the default decimal delimiter for Money.to_string
  delimiter: ",",
  # don’t display the currency symbol in Money.to_string
  symbol: false,
  # position the symbol
  symbol_on_right: false,
  # add a space between symbol and number
  symbol_space: false,
  # display units after the delimiter
  fractional_unit: true,
  # don’t display the insignificant zeros or the delimiter
  strip_insignificant_zeros: false,
  # add the currency code after the number
  code: false,
  # display the minus sign before the currency symbol for Money.to_string
  minus_sign_first: true,
  # don't display the delimiter or fractional units if the fractional units are only insignificant zeros
  strip_insignificant_fractional_unit: false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
