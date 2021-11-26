use Mix.Config

config :docpipe, Docpipe.Repo,
  adapter: Ecto.Adapters.SQLite3,
  database: "/database.sq3"

config :docpipe,
  ecto_repos: [Docpipe.Repo]
