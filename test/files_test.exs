defmodule Docpipe.DocumentsTest do
  use ExUnit.Case
  alias Docpipe.Documents

  @path Path.join(:code.priv_dir(:docpipe), "test_input")

  defp start_db(state) do
    Supervisor.start_link([Docpipe.Repo], name: __MODULE__, strategy: :one_for_one)
    state
  end

  defp create_dirs(state) do
    File.mkdir(@path)
    state
  end

  defp create_local_documents() do
    File.touch(@path <> "/document1.html")
    File.touch(@path <> "/document2.html")
    File.touch(@path <> "/document3.pdf")
    File.mkdir(@path <> "/test_dir")
    File.touch(@path <> "/test_dir/document3.html")
    File.touch(@path <> "/test_dir/document4.html")
  end

  defp delete_local_documents() do
    File.rm(@path <> "/document1.html")
    File.rm(@path <> "/document2.html")
    File.touch(@path <> "/document3.pdf")
    File.mkdir(@path <> "/test_dir/document3.html")
    File.mkdir(@path <> "/test_dir/document4.html")
    File.rmdir(@path <> "/test_dir")
  end

  describe "documents" do
    alias Docpipe.Documents.Files

    setup [
      :create_dirs
    ]

    @valid_attrs %{
      old_path: "/some/path/",
      new_path: "/some/new/path/",
      old_name: "old name",
      new_name: "new name",
      alias_type: "local",
      alias_id: "document.ext"
    }
    @update_attrs %{
      old_path: "/some/updated/path/",
      new_path: "/some/new/updated/path/",
      old_name: "old name",
      new_name: "updated name",
      alias_type: "local",
      alias_id: "document.ext"
    }
    @invalid_attrs %{base_url: nil, name: nil}

    def document_fixture(attrs \\ %{}) do
      {:ok, document} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Documents.create()

      document
    end

    test "list/0 returns all documents" do
      document = document_fixture()
      assert Documents.list() == [document]
      Documents.delete_all()
    end

    test "list/1 returns all documents" do
      create_local_documents()
      documents = Documents.list([source: :file_system])
      assert documents == ["document3.pdf", "document2.html", "document1.html", "test_dir/document4.html", "test_dir/document3.html"]
    end

    test "list/1 with filter opts returns documents with the specified extension" do
      create_local_documents()
      documents = Documents.list([source: :file_system, filters: [extensions: ["html"]]])
      assert documents == ["document2.html", "document1.html", "test_dir/document4.html", "test_dir/document3.html"]
    end

    test "cast_file_system/1 returns a document struct" do
      result = %{
        old_file_name: "document_4.html",
        old_path: "/test_dir"
      }
      assert Documents.cast_file_system("/test_dir/document_4.html") == result
    end
  end
end
