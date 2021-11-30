defmodule Mix.Tasks.MakeDocumentIndex do
  @shortdoc "Builds an index of all the documents in the migration source directory and writes them to the database."
  use Mix.Task
  alias Docpipe.Documents

  @impl Mix.Task
  def run(args) do
    Application.ensure_all_started(:docpipe)
    Documents.list([source: :file_system, filters: [extensions: args]])
    |> Enum.map(&Documents.cast_file_system/1)
    |> Enum.map(&Documents.create/1)
  end
end

defmodule Mix.Tasks.ReviewDocuments do
  @shortdoc "Iterates through the documents in the index, allowing the user to specify destination document names and paths."
  use Mix.Task
  alias Docpipe.Documents
  alias Console.DocumentsConsole

  @impl Mix.Task
  def run(_args) do
    Application.ensure_all_started(:docpipe)
    Documents.list([source: :repo, filters: [completed: true]])
    |> Enum.each(fn(document) ->
      :ok = DocumentsConsole.handle_user_input(document)
    end)
  end
end
