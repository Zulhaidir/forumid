defmodule Forumid.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories, primary_key: false, options: "ENGINE=ROCKSDB") do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :slug, :string
      add :description, :text
      add :lock_version, :integer, default: 1, null: false
      add :user_id, :binary_id, null: false
      timestamps(type: :utc_datetime)
    end

    create index(:categories, [:user_id])
    create unique_index(:categories, [:slug])
  end
end
