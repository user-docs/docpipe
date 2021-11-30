defmodule Console.DocumentsConsole do
  alias Docpipe.Documents

  def menu(document) do
    """
      Title: #{document.old_name}
      Located at: #{document.old_path} / #{document.old_file_name}

      New Title: #{document.new_name}
      Target location: #{document.new_path} / #{document.new_file_name}

      1. Update Title
      2. Update Path
      3. Update File Name
      4. Next
      5. Mark Complete
    """
  end

  def handle_user_input(document) do
    IO.puts(menu(document))
    Task.async(fn -> IO.gets "Pick your poison\n->" end)
    |> Task.await(:infinity)
    |> String.replace("\n", "")
    |> String.to_integer()
    |> case do
      1 -> handle_user_update(document, :new_name)
      2 -> handle_user_update(document, :new_path)
      3 -> handle_user_update(document, :new_file_name)
      4 -> :ok
      5 ->
        Documents.update(document, %{complete: true})
        :ok
    end
  end

  def handle_user_update(document, field) do
    new_value =
      Task.async(fn -> IO.gets "Enter a new value\n->" end)
      |> Task.await(:infinity)
      |> String.replace("\n", "")

    attrs = %{field => new_value}
    case Documents.update(document, attrs) do
      {:ok, document} -> handle_user_input(document)
      {:error, changeset} ->
        {message, _meta} = changeset.errors |> Keyword.get(field)
        IO.puts("""
          ERROR: #{message}
          Changes not made, try again
        """)
        handle_user_update(document, field)
    end
  end
end
