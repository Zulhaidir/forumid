defmodule Forumid.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags, primary_key: false, options: "ENGINE=ROCKSDB") do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :slug, :string
      add :lock_version, :integer, default: 1, null: false
      timestamps(type: :utc_datetime)
    end

    # slug unik, agar tidak ada slug ganda
    create unique_index(:tags, [:slug])
  end
end
