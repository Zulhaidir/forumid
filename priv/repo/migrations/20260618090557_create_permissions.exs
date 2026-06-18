defmodule Forumid.Repo.Migrations.CreatePermissions do
  use Ecto.Migration

  def change do
    create table(:permissions, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :resource, :string, null: false
      add :action, :string, null: false
      add :description, :text

      timestamps(type: :utc_datetime)
    end

    create unique_index(:permissions, [:resource, :action])
  end
end
