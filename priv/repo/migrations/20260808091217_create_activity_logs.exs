defmodule Forumid.Repo.Migrations.CreateActivityLogs do
  use Ecto.Migration

  def change do
    create table(:activity_logs, primary_key: false, options: "ENGINE=ROCKSDB") do
      add :id, :binary_id, primary_key: true
      add :action, :string
      add :resource, :string
      add :resource_id, :binary_id, null: false
      add :description, :text
      add :lock_version, :integer, default: 1, null: false
      add :user_id, :binary_id, null: false
      timestamps(type: :utc_datetime)
    end

    create index(:activity_logs, [:user_id])
    create index(:activity_logs, [:resource_id])
  end
end
