defmodule Docpipe.Files do
  @moduledoc """
  The Files context.
  """
  import Ecto.Query, warn: false
  alias Docpipe.Repo

  alias Docpipe.Files.File

  if Mix.env() in [:test] do
    @source_path Path.join(:code.priv_dir(:docpipe), "test_input")
  else
    @source_path Application.get_env(:docpipe, :input_dir)
  end

  def list(opts \\ [source: :repo]) do
    case opts[:source] do
      :repo -> list_repo(opts)
      :file_system -> list_file_system(@source_path, opts)
    end
  end

  def list_repo(opts) do
    filters = Keyword.get(opts, :filters, [])
    from(file in File)
    |> maybe_filter_completed_files(filters[:completed])
    |> Repo.all()
  end

  def maybe_filter_completed_files(files, nil), do: files
  def maybe_filter_completed_files(files, _) do
    from(file in files, where: file.complete == false or is_nil(file.complete))
  end

  def list_file_system(path, opts) do
    filters = Keyword.get(opts, :filters, [])
    {:ok, files} = Elixir.File.ls(path)

    files
    |> Enum.reduce([], fn(file_name, acc) ->
      case Elixir.File.dir?(Path.join(@source_path, file_name)) do
        true -> acc ++ list_file_system(Path.join(path, file_name), opts)
        false ->
          relative_path =
            path
            |> Path.join(file_name)
            |> Path.relative_to(@source_path)

          [ relative_path | acc]
      end
    end)
    |> maybe_filter_by_extension(filters[:extensions])
  end

  def maybe_filter_by_extension(files, nil), do: files
  def maybe_filter_by_extension(files, extensions) do
    Enum.filter(files, fn(file) ->
      ext =
        file
        |> Path.basename()
        |> Path.extname()
        |> String.replace(".", "")

      if ext in extensions, do: true, else: false
    end)
  end

  def create(attrs) do
    %File{}
    |> File.changeset(attrs)
    |> Repo.insert()
  end

  def update(file, attrs) do
    file
    |> File.changeset(attrs)
    |> Repo.update()
  end

  def delete_all() do
    from(file in File)
    |> Repo.delete_all()
  end

  def cast_file_system(file) do
    %{
      old_path: Path.dirname(file),
      old_file_name: Path.basename(file)
    }
  end
end
