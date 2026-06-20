defmodule Forumid.Content do
  import Ecto.Query, warn: false

  alias Forumid.Repo
  alias Forumid.Content.Article
  alias Forumid.Content.ArticleMedia

  ## -----------------------------------------
  ## Article
  ## -----------------------------------------

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
  def update_article(%Article{} = article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update()
  end

  ## DELETE
  def delete_article(%Article{} = article) do
    Repo.delete(article)
  end

  ## CHANGE
  def change_article(%Article{} = article, attrs \\ %{}) do
    Article.changeset(article, attrs)
  end

  ## -----------------------------------------
  ## Article Media
  ## -----------------------------------------

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
    |> Repo.update()
  end

  ## DELETE
  def delete_article_media(%ArticleMedia{} = article_media) do
    Repo.delete(article_media)
  end

  ## CHANGE
  def change_article_media(%ArticleMedia{} = article_media, attrs \\ %{}) do
    ArticleMedia.changeset(article_media, attrs)
  end

  ## -----------------------------------------
  ## Helper
  ## -----------------------------------------

  ## LIST (by article_id)
  def list_article_media_by_article_id(article_id) do
    ArticleMedia
    |> where([am], am.article_id == ^article_id)
    |> order_by([am], asc: am.sort_order)
    |> Repo.all()
  end

  ## LIST (with preload)
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

  ## GET (by id)
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

  ## GET (by slug)
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
end
