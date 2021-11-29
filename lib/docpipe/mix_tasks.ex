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

defmodule Mix.Tasks.ReviewFiles do
  @shortdoc "Iterates through the files in the index, allowing the user to specify destination file names and paths."
  use Mix.Task
  alias Docpipe.Files
  alias Console.FilesConsole

  @impl Mix.Task
  def run(_args) do
    Application.ensure_all_started(:docpipe)
    Files.list([source: :repo, filters: [completed: true]])
    |> Enum.each(fn(file) ->
      :ok = FilesConsole.handle_user_input(file)
    end)
  end
end
