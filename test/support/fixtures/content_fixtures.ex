defmodule Forumid.ContentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Forumid.Content` context.
  """

  import Forumid.AccountsFixtures

  @doc """
  Generate a article.
  """
  def article_fixture(attrs \\ %{}) do
    author = user_fixture()

    attrs =
      Enum.into(attrs, %{
        title: "My first article",
        slug: "my-first-article",
        excerpt: "This is an article excerpt.",
        content: "This is the full article content.",
        featured_image: "/uploads/articles/default.jpg",
        status: "draft",
        published_at: nil,
        author_id: author.id
      })

    {:ok, article} = Forumid.Content.create_article(attrs)

    article
  end
end
