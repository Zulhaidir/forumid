defmodule Forumid.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles, primary_key: false, options: "ENGINE=ROCKSDB") do
      add :id, :binary_id, primary_key: true

      add :title, :string, null: false
      add :slug, :string, null: false

      add :excerpt, :text
      add :content, :text, null: false

      add :featured_image, :string
      add :status, :string, null: false, default: "draft"

      add :published_at, :utc_datetime
      add :author_id, :binary_id, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:articles, [:slug])
    create index(:articles, [:author_id])
    create index(:articles, [:status])
    create index(:articles, [:published_at])
  end
end
