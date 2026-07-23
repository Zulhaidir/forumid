defmodule Forumid.Content.Article do
  use Forumid.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Forumid.Accounts.User
  alias Forumid.Content.ArticleMedia

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
  ## perpare_changes mencegah masalah race condition (di mana data induk tiba-tiba dihapus oleh pengguna lain tepat sebelum data anak disimpan).
  defp validate_author_exists(changeset) do
    changeset
    |> prepare_changes(fn changeset ->
      user_id = get_field(changeset, :author_id)

      author_exists? =
        User
        |> where([u], u.id == ^user_id)
        |> lock("FOR UPDATE")
        |> changeset.repo.exists?()

      case author_exists? do
        true -> changeset
        false -> add_error(changeset, :author_id, "penulis tidak ditemukan")
      end
    end)
  end
end
