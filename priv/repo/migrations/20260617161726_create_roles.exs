defmodule Forumid.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles, primary_key: false, options: "ENGINE=ROCKSDB") do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :description, :text
      add :lock_version, :integer, default: 1, null: false
      timestamps(type: :utc_datetime)
    end

    create unique_index(:roles, [:name])
  end
end
