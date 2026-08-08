defmodule Forumid.Content do
  import Ecto.Query, warn: false

  alias Forumid.Repo
  alias Forumid.Content.Article
  alias Forumid.Content.ArticleMedia

  ## =========================================
  ## Article
  ## =========================================

  ## ----------------- CRUD ------------------
  ## LIST
  def list_articles do
    Repo.all(Article)
  end

  ## GET
  def get_article!(id), do: Repo.get!(Article, id)

  ## CREATE
  def create_article(attrs \\ %{}) do
    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
  end

  ## UPDATE
  ## Menggunakan optimistic_lock
  def update_article(%Article{} = article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update(
      stale_error_field: :lock_version,
      stale_error_message:
        "artikel ini sudah diubah oleh orang lain, silakan muat ulang data terbaru"
    )
  end

  ## DELETE
  def delete_article(%Article{} = article) do
    delete_article_relationships(article)
  end

  ## CHANGE
  def change_article(%Article{} = article, attrs \\ %{}) do
    Article.changeset(article, attrs)
  end

  ## --------------- Helper ------------------
  ## List
  def list_articles_with_media do
    Article
    |> Repo.all()
    |> Repo.preload(:article_media)
  end

  def list_articles_full do
    Article
    |> order_by([a], desc: a.inserted_at)
    |> Repo.all()
    |> Repo.preload([:author, :article_media])
  end

  def list_published_articles(status \\ "published") do
    Article
    |> where([a], a.status == ^status)
    |> order_by([a], desc: a.published_at)
    |> Repo.all()
    |> Repo.preload([:author])
  end

  def list_active_sessions(user_id) do
    Article
    |> where([a], a.author_id == ^user_id)
    |> order_by([a], desc: a.inserted_at)
    |> Repo.all()
  end

  ## Lookup
  def get_article_by_slug(slug) do
    Repo.get_by(Article, slug: slug)
  end

  def get_article_by_slug!(slug) do
    Repo.get_by!(Article, slug: slug)
  end

  def article_by_slug!(slug) do
    Article
    |> Repo.get_by!(slug: slug)
    |> Repo.preload([:author, :article_media])
  end

  def get_article_with_media!(id) do
    Article
    |> Repo.get!(id)
    |> Repo.preload(:article_media)
  end

  def get_article_full!(id) do
    Article
    |> Repo.get!(id)
    |> Repo.preload([:author, :article_media])
  end

  ## Relationship Operation
  defp delete_article_relationships(%Article{} = article) do
    media_list =
      ArticleMedia
      |> where([am], am.article_id == ^article.id)
      |> Repo.all()

    multi =
      Enum.reduce(media_list, Ecto.Multi.new(), fn media, multi ->
        Ecto.Multi.delete(multi, {:delete_media, media.id}, media)
      end)
      |> Ecto.Multi.delete(:delete_article, article)

    case Repo.transact(multi) do
      {:ok, %{delete_article: deleted}} ->
        {:ok, deleted}

      {:error, _step, reason, _changes} ->
        {:error, reason}
    end
  end

  ## =========================================
  ##  Article Media
  ## =========================================

  ## ----------------- CRUD ------------------
  ## LIST
  def list_article_media do
    Repo.all(ArticleMedia)
  end

  ## GET
  def get_article_media!(id), do: Repo.get!(ArticleMedia, id)

  ## CREATE
  def create_article_media(attrs \\ %{}) do
    %ArticleMedia{}
    |> ArticleMedia.changeset(attrs)
    |> Repo.insert()
  end

  ## UPDATE
  def update_article_media(%ArticleMedia{} = article_media, attrs) do
    article_media
    |> ArticleMedia.changeset(attrs)
    |> Repo.update(
      stale_error_field: :lock_version,
      stale_error_message:
        "media ini sudah diubah oleh orang lain, silakan muat ulang data terbaru"
    )
  end

  ## DELETE
  def delete_article_media(%ArticleMedia{} = article_media) do
    Repo.delete(article_media)
  end

  ## CHANGE
  def change_article_media(%ArticleMedia{} = article_media, attrs \\ %{}) do
    ArticleMedia.changeset(article_media, attrs)
  end

  ## --------------- Helper ------------------
  ## List
  def list_article_media_by_article_id(article_id) do
    ArticleMedia
    |> where([am], am.article_id == ^article_id)
    |> order_by([am], asc: am.sort_order)
    |> Repo.all()
  end

  @doc "Mengambil artikel milik user tertentu"
  def list_articles_by_user(user_id) do
    Article
    |> where([a], a.author_id == ^user_id)
    |> order_by([a], desc: a.inserted_at)
    |> Repo.all()
  end
end
