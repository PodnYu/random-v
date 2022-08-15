defmodule RandomV.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # run tests with another port
    port = if(Mix.env() == :test, do: 4002, else: 4001)

    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: RandomV.LinkController,
        options: [port: port]
      )
    ]

    opts = [strategy: :one_for_one, name: RandomV.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
