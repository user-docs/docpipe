defmodule Docpipe.FilesTest do
  use ExUnit.Case
  alias Docpipe.Files

  @path Path.join(:code.priv_dir(:docpipe), "test_input")

  defp start_db(state) do
    Supervisor.start_link([Docpipe.Repo], name: __MODULE__, strategy: :one_for_one)
    state
  end

  defp create_dirs(state) do
    File.mkdir(@path)
    state
  end

  defp create_local_files() do
    File.touch(@path <> "/file1.html")
    File.touch(@path <> "/file2.html")
    File.touch(@path <> "/file3.pdf")
    File.mkdir(@path <> "/test_dir")
    File.touch(@path <> "/test_dir/file3.html")
    File.touch(@path <> "/test_dir/file4.html")
  end

  defp delete_local_files() do
    File.rm(@path <> "/file1.html")
    File.rm(@path <> "/file2.html")
    File.touch(@path <> "/file3.pdf")
    File.mkdir(@path <> "/test_dir/file3.html")
    File.mkdir(@path <> "/test_dir/file4.html")
    File.rmdir(@path <> "/test_dir")
  end

  describe "files" do
    alias Docpipe.Files.File

    setup [
      :create_dirs
    ]

    @valid_attrs %{
      old_path: "/some/path/",
      new_path: "/some/new/path/",
      old_name: "old name",
      new_name: "new name",
      alias_type: "local",
      alias_id: "file.ext"
    }
    @update_attrs %{
      old_path: "/some/updated/path/",
      new_path: "/some/new/updated/path/",
      old_name: "old name",
      new_name: "updated name",
      alias_type: "local",
      alias_id: "file.ext"
    }
    @invalid_attrs %{base_url: nil, name: nil}

    def file_fixture(attrs \\ %{}) do
      {:ok, file} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Files.create()

      file
    end

    test "list/0 returns all files" do
      file = file_fixture()
      assert Files.list() == [file]
      Files.delete_all()
    end

    test "list/1 returns all files" do
      create_local_files()
      files = Files.list([source: :file_system])
      assert files == ["file3.pdf", "file2.html", "file1.html", "test_dir/file4.html", "test_dir/file3.html"]
    end

    test "list/1 with filter opts returns files with the specified extension" do
      create_local_files()
      files = Files.list([source: :file_system, filters: [extensions: ["html"]]])
      assert files == ["file2.html", "file1.html", "test_dir/file4.html", "test_dir/file3.html"]
    end

    test "cast_file_system/1 returns a file struct" do
      result = %{
        old_file_name: "file_4.html",
        old_path: "/test_dir"
      }
      assert Files.cast_file_system("/test_dir/file_4.html") == result
    end
  end
end
