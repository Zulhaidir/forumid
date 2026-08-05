defmodule Forumid.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false, options: "ENGINE=ROCKSDB") do
      add :id, :binary_id, primary_key: true
      add :body, :text
      add :lock_version, :integer, default: 1, null: false
      add :topic_id, :binary_id, null: false
      add :user_id, :binary_id, null: false
      timestamps(type: :utc_datetime)
    end

    create index(:posts, [:topic_id])
    create index(:posts, [:user_id])
  end
end
