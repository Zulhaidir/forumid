defmodule Forumid.Content.ArticleMedia do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @media_types ["image", "video", "audio", "document"]

  schema "article_media" do
    field :media_type, :string
    field :file_path, :string
    field :sort_order, :integer
    field :caption, :string
    field :alt_text, :string

    belongs_to :article, Forumid.Content.Article

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
    |> foreign_key_constraint(:article_id)
    |> unique_constraint([:article_id, :sort_order])
  end
end
