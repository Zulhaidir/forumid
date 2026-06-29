defmodule Forumid.Repo.Migrations.CreateRolePermissions do
  use Ecto.Migration

  def change do
    create table(:role_permissions, primary_key: false, options: "ENGINE=ROCKSDB") do
      add :id, :binary_id, primary_key: true

      add :role_id, :binary_id, null: false
      add :permission_id, :binary_id, null: false

      # Audit trail
      add :granted_by, :binary_id
      add :granted_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:role_permissions, [:role_id, :permission_id])

    create index(:role_permissions, [:role_id])
    create index(:role_permissions, [:permission_id])
    create index(:role_permissions, [:granted_by])
    create index(:role_permissions, [:granted_at])
  end
end
