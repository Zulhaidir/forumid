defmodule Forumid.Content.ArticleMedia do
  use Forumid.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Forumid.Content.Article

  @media_types ["image", "video", "audio", "document"]

  schema "article_media" do
    field :media_type, :string
    field :file_path, :string
    field :sort_order, :integer, default: 0
    field :caption, :string
    field :alt_text, :string

    belongs_to :article, Article

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(article_media, attrs) do
    article_media
    |> cast(attrs, [
      :article_id,
      :media_type,
      :file_path,
      :sort_order,
      :caption,
      :alt_text
    ])
    |> validate_required([
      :article_id,
      :media_type,
      :file_path
    ])
    |> validate_inclusion(:media_type, @media_types)
    |> validate_number(:sort_order, greater_than_or_equal_to: 0)
    |> validate_article_exists()
    |> unique_constraint(:article_id, name: :article_media_article_id_sort_order_index)
  end

  ## Pengganti foreign_key_constraint(:article_id)
  ## prepare_changes mencegah masalah race condition (di mana data induk tiba-tiba dihapus oleh pengguna lain tepat sebelum data anak disimpan).
  defp validate_article_exists(changeset) do
    changeset
    |> prepare_changes(fn changeset ->
      article_id = get_field(changeset, :article_id)

      article_exists? =
        Article
        |> where([a], a.id == ^article_id)
        |> lock("FOR UPDATE")
        |> changeset.repo.exists?()

      case article_exists? do
        true -> changeset
        false -> add_error(changeset, :article_id, "article tidak ditemukan")
      end
    end)
  end
end
