use Mix.Config

config :docpipe,
  input_dir: "D:\\test_input",
  plaintext_rules_config: "D:\\test_input\\config.json",
  ecto_repos: [Docpipe.Repo]

config :docpipe, Docpipe.Repo,
  adapter: Ecto.Adapters.SQLite3,
  database: "D:\\test_input\\database\\docpipe.sqlite3"

import_config "#{Mix.env()}.exs"
if Mix.env() in [:dev, :test] do
end
