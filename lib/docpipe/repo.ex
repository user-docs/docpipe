defmodule Docpipe.Repo do
  use Ecto.Repo, otp_app: :docpipe, adapter: Ecto.Adapters.SQLite3
end
