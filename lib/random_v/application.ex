defmodule RandomV.Application do
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    port = Application.get_env(:youtube_random_v, :port)

    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: RandomV.LinkController,
        options: [port: port]
      )
    ]

    opts = [strategy: :one_for_one, name: RandomV.Supervisor]
    result = Supervisor.start_link(children, opts)

    Logger.info("Listening on :#{port}")

    result
  end
end
