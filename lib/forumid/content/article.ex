defmodule Forumid.Content.Article do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @statuses ["draft", "published", "archived"]
  schema "articles" do
    field :title, :string
    field :slug, :string
    field :excerpt, :string
    field :content, :string
    field :featured_image, :string
    field :status, :string
    field :published_at, :utc_datetime

    belongs_to :author, Forumid.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [
      :title,
      :slug,
      :excerpt,
      :content,
      :featured_image,
      :status,
      :published_at,
      :author_id
    ])
    |> validate_required([
      :title,
      :slug,
      :content,
      :status,
      :author_id
    ])
    |> validate_length(:title, min: 5, max: 255)
    |> validate_length(:slug, min: 3, max: 255)
    |> validate_length(:content, min: 20)
    |> validate_length(:excerpt, max: 500)
    |> validate_inclusion(:status, @statuses)
    |> unique_constraint(:slug)
  end
end
