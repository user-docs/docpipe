defmodule Mix.Tasks.MakeFileIndex do
  @shortdoc "Builds an index of all the files in the migration source directory and writes them to the database."
  use Mix.Task
  alias Docpipe.Files

  @impl Mix.Task
  def run(args) do
    Application.ensure_all_started(:docpipe)
    Files.list([source: :file_system, filters: [extensions: args]])
    |> Enum.map(&Files.cast_file_system/1)
    |> Enum.map(&Files.create/1)
  end
end
