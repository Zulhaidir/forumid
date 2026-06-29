defmodule Forumid.Repo.Migrations.CreateUserProfiles do
  use Ecto.Migration

  def change do
    ## user_profiles
    create table(:user_profiles, primary_key: false, options: "ENGINE=ROCKSDB") do
      add :id, :binary_id, primary_key: true
      add :full_name, :string
      add :username, :string
      add :avatar_url, :string
      add :bio, :text
      add :phone, :string
      add :is_active, :boolean, default: false, null: false
      add :user_id, :binary_id, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:user_profiles, [:username])
    create unique_index(:user_profiles, [:user_id])
  end
end
