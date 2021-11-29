defmodule Docpipe.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    Logger.info("Starting #{__MODULE__}")
    children = [
      Docpipe.Repo
    ]
    opts = [strategy: :one_for_one, name: UserDocsWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
