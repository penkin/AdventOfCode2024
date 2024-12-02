defmodule AdventOfCode.MixProject do
  use Mix.Project

  def project do
    [
      app: :adventofcode,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:aoc, "~> 0.13"}
    ]
  end

  def cli do
    [
      preferred_envs: ["aoc.test": :test]
    ]
  end
end
