defmodule Console.FilesConsole do
  alias Docpipe.Files

  def menu(file) do
    """
      Title: #{file.old_name}
      Located at: #{file.old_path} / #{file.old_file_name}

      New Title: #{file.new_name}
      Target location: #{file.new_path} / #{file.new_file_name}

      1. Update Title
      2. Update Path
      3. Update File Name
      4. Next
      5. Mark Complete
    """
  end

  def handle_user_input(file) do
    IO.puts(menu(file))
    Task.async(fn -> IO.gets "Pick your poison\n->" end)
    |> Task.await(:infinity)
    |> String.replace("\n", "")
    |> String.to_integer()
    |> case do
      1 -> handle_user_update(file, :new_name)
      2 -> handle_user_update(file, :new_path)
      3 -> handle_user_update(file, :new_file_name)
      4 -> :ok
      5 ->
        Files.update(file, %{complete: true})
        :ok
    end
  end

  def handle_user_update(file, field) do
    new_value =
      Task.async(fn -> IO.gets "Enter a new value\n->" end)
      |> Task.await(:infinity)
      |> String.replace("\n", "")

    attrs = %{field => new_value}
    case Files.update(file, attrs) do
      {:ok, file} -> handle_user_input(file)
      {:error, changeset} ->
        {message, _meta} = changeset.errors |> Keyword.get(field)
        IO.puts("""
          ERROR: #{message}
          Changes not made, try again
        """)
        handle_user_update(file, field)
    end
  end
end
