import Config

# rename secrets.example.exs to secrets.exs and change the values
import_config "secrets.exs"

config :youtube_random_v,
  port: if(Mix.env() == :dev, do: 4001, else: 4002)

config :logger,
  level: :debug
