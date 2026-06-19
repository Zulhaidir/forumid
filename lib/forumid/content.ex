defmodule Forumid.Content do
  import Ecto.Query, warn: false

  alias Forumid.Repo
  alias Forumid.Content.Article

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
end
