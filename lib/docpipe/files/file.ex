defmodule Docpipe.Files.File do
  use Ecto.Schema
  import Ecto.Changeset

  @all_fields [:old_path, :old_file_name, :new_path, :new_file_name, :old_name, :new_name, :alias_type, :alias_id]

  @derive Jason.Encoder
  schema "files" do
    field :old_path, :string
    field :old_file_name, :string
    field :new_path, :string
    field :new_file_name, :string
    field :old_name, :string
    field :new_name, :string
    field :alias_type, Ecto.Enum, values: [:local, :confluence]
    field :alias_id, :string
    timestamps()
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, @all_fields)
    |> unique_constraint([:old_path, :old_file_name], name: :unique_path)
  end
end
