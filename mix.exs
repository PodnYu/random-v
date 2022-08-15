defmodule RandomV.MixProject do
  use Mix.Project

  def project do
    [
      app: :youtube_random_v,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      mod: {RandomV.Application, []}
    ]
  end

  def application do
    [
      extra_applications: [:logger, :httpoison, :plug_cowboy],
      mod: {RandomV.Application, []}
    ]
  end

  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 3.1"},
      {:httpoison, ">= 0.0.0"}
    ]
  end
end
