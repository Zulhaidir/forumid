defmodule Forumid.Content.ArticleMedia do
  use Ecto.Schema
  import Ecto.Changeset

  alias Forumid.Repo
  alias Forumid.Content.Article

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

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
    |> unique_constraint([:article_id, :sort_order])
  end

  ## Pengganti foreign_key_constraint(:article_id)
  defp validate_article_exists(changeset) do
    article_id = get_field(changeset, :article_id)

    if article_id do
      case Repo.get(Article, article_id) do
        nil -> add_error(changeset, :article_id, "artikel tidak di temukan")
        _ -> changeset
      end
    else
      changeset
    end
  end
end
