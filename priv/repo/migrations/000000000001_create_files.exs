defmodule MyRepo.Migrations.AddDocumentsTable do
  use Ecto.Migration

  def change do
    create table("documents") do
      add :old_path,        :string
      add :old_file_name,   :string
      add :new_path,        :string
      add :new_file_name,   :string
      add :old_name,        :string
      add :new_name,        :string
      add :alias_type,      :string
      add :alias_id,        :string
      add :complete,        :boolean

      timestamps()
    end
    index("documents", [:old_path, :old_file_name], unique: true, name: :unique_path)
  end
end
