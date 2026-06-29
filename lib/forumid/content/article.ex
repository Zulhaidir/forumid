defmodule Forumid.Content.Article do
  use Ecto.Schema
  import Ecto.Changeset

  alias Forumid.Repo
  alias Forumid.Accounts.User
  alias Forumid.Content.ArticleMedia

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

    belongs_to :author, User
    has_many :article_media, ArticleMedia, preload_order: [asc: :sort_order]

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
    |> validate_author_exists()
    |> unique_constraint(:slug)
  end

  ## Pengganti foreign_key_constraint(:author_id)
  defp validate_author_exists(changeset) do
    author_id = get_field(changeset, :author_id)

    if author_id do
      case Repo.get(User, author_id) do
        nil -> add_error(changeset, :author_id, "penulis tidak ditemukan")
        _ -> changeset
      end
    else
      changeset
    end
  end
end
