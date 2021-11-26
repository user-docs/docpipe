defmodule Docpipe.MixProject do
  use Mix.Project

  def project do
    [
      app: :docpipe,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Docpipe.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:desktop, "~> 1.3.0"},
      {:file_system, "~> 0.2"},
      {:ecto, "~> 3.7"},
      {:jason, "~> 1.2"},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:panpipe, "~> 0.2"},
      {:ecto_sqlite3, "~> 0.7.1"},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      test: ["ecto.drop", "ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
