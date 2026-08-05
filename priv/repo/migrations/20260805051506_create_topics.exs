defmodule Forumid.Repo.Migrations.CreateTopics do
  use Ecto.Migration

  def change do
    create table(:topics, primary_key: false, options: "ENGINE=ROCKSDB") do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :slug, :string
      add :body, :text
      add :views, :integer, default: 0
      add :is_pinned, :boolean, default: false, null: false
      add :is_locked, :boolean, default: false, null: false
      add :lock_version, :integer, default: 1, null: false
      add :category_id, :binary_id, null: false
      add :user_id, :binary_id, null: false
      timestamps(type: :utc_datetime)
    end

    create index(:topics, [:category_id])
    create index(:topics, [:user_id])
    create unique_index(:topics, [:slug])
  end
end
