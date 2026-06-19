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
end
