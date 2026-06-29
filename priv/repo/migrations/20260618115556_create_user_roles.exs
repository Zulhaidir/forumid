defmodule Forumid.Repo.Migrations.CreateUserRoles do
  use Ecto.Migration

  def change do
    create table(:user_roles, primary_key: false, options: "ENGINE=ROCKSDB") do
      add :id, :binary_id, primary_key: true

      add :user_id, :binary_id, null: false
      add :role_id, :binary_id, null: false

      add :assigned_by, :binary_id
      add :assigned_at, :utc_datetime

      add :is_active, :boolean, default: true, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:user_roles, [:user_id, :role_id])

    create index(:user_roles, [:user_id])
    create index(:user_roles, [:role_id])
    create index(:user_roles, [:assigned_by])
    create index(:user_roles, [:is_active])
  end
end
