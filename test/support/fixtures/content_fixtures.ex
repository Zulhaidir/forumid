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

  @doc """
  Generate an article_media.
  """
  def article_media_fixture(attrs \\ %{}) do
    article = article_fixture()

    attrs =
      Enum.into(attrs, %{
        article_id: article.id,
        media_type: "image",
        file_path: "/uploads/articles/image-1.jpg",
        sort_order: 0,
        caption: "Sample image",
        alt_text: "Sample alt text"
      })

    {:ok, article_media} =
      Forumid.Content.create_article_media(attrs)

    article_media
  end
end
