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
    File.mkdir(@path <> "/test_dir")
    File.touch(@path <> "/test_dir/file3.html")
    File.touch(@path <> "/test_dir/file4.html")
  end

  defp delete_local_files() do
    File.rm(@path <> "/file1.html")
    File.rm(@path <> "/file2.html")
    File.mkdir(@path <> "/test_dir/file3.html")
    File.mkdir(@path <> "/test_dir/file4.html")
    File.rmdir(@path <> "/test_dir")
  end

  describe "files" do
    alias Docpipe.Files.File

    setup [
      :start_db,
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
      assert files == ["file2.html", "file1.html", "test_dir/file4.html", "test_dir/file3.html"]
    end

    test "cast_file_system/1 returns a file struct" do
      result = %{
        old_file_name: "file_4.html",
        old_path: "/test_dir"
      }
      assert Files.cast_file_system("/test_dir/file_4.html") == result
    end

    """

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Projects.get_project!(project.id) == project
    end

    test "create_project/1 with valid data creates a project" do
      strategy = UserDocs.WebFixtures.strategy()
      team = UserDocs.UsersFixtures.team()
      attrs = @valid_attrs |> Map.put(:strategy_id, strategy.id) |> Map.put(:team_id, team.id)
      assert {:ok, %Project{} = project} = Projects.create_project(attrs)
      assert project.base_url == "some base_url"
      assert project.name == "some name"
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      assert {:ok, %Project{} = project} = Projects.update_project(project, @update_attrs)
      assert project.base_url == "some updated base_url"
      assert project.name == "some updated name"
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Projects.update_project(project, @invalid_attrs)
      assert project == Projects.get_project!(project.id)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Projects.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Projects.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Projects.change_project(project)
    end
    """
  end
end
