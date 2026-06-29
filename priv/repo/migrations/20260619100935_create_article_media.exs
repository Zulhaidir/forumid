defmodule Forumid.Repo.Migrations.CreateArticleMedia do
  use Ecto.Migration

  def change do
    create table(:article_media, primary_key: false, options: "ENGINE=ROCKSDB") do
      add :id, :binary_id, primary_key: true
      add :article_id, :binary_id, null: false
      add :media_type, :string, null: false
      add :file_path, :string, null: false
      add :sort_order, :integer, null: false, default: 0
      add :caption, :text
      add :alt_text, :string

      timestamps(type: :utc_datetime)
    end

    create index(:article_media, [:article_id])
    create unique_index(:article_media, [:article_id, :sort_order])
  end
end
