defmodule Forumid.ContentTest do
  use Forumid.DataCase

  alias Forumid.Content

  describe "articles" do
    alias Forumid.Content.Article

    import Forumid.ContentFixtures
    import Forumid.AccountsFixtures

    @invalid_attrs %{
      title: nil,
      slug: nil,
      content: nil,
      status: nil,
      author_id: nil
    }

    test "list_articles/0 returns all articles" do
      article = article_fixture()
      assert Content.list_articles() == [article]
    end

    test "get_article!/1 returns the article with given id" do
      article = article_fixture()
      assert Content.get_article!(article.id) == article
    end

    test "create_article/1 with valid data creates an article" do
      author = user_fixture()

      valid_attrs = %{
        title: "Some Title",
        slug: "some-title",
        excerpt: "Some excerpt",
        content: "This article contains more than twenty characters.",
        featured_image: "/uploads/articles/default.jpg",
        status: "draft",
        published_at: nil,
        author_id: author.id
      }

      assert {:ok, %Article{} = article} =
               Content.create_article(valid_attrs)

      assert article.title == "Some Title"
      assert article.slug == "some-title"
      assert article.excerpt == "Some excerpt"
      assert article.content == "This article contains more than twenty characters."
      assert article.featured_image == "/uploads/articles/default.jpg"
      assert article.status == "draft"
      assert article.published_at == nil
      assert article.author_id == author.id
    end

    test "create_article/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Content.create_article(@invalid_attrs)
    end

    test "update_article/2 with valid data updates the article" do
      article = article_fixture()

      update_attrs = %{
        title: "Updated Title",
        slug: "updated-title",
        excerpt: "Updated excerpt",
        content: "This is an updated article content used for testing.",
        featured_image: "/uploads/articles/updated.jpg",
        status: "published",
        published_at: ~U[2026-06-18 13:54:00Z],
        author_id: article.author_id
      }

      assert {:ok, %Article{} = article} =
               Content.update_article(article, update_attrs)

      assert article.title == "Updated Title"
      assert article.slug == "updated-title"
      assert article.excerpt == "Updated excerpt"
      assert article.content == "This is an updated article content used for testing."
      assert article.featured_image == "/uploads/articles/updated.jpg"
      assert article.status == "published"
      assert article.published_at == ~U[2026-06-18 13:54:00Z]
    end

    test "update_article/2 with invalid data returns error changeset" do
      article = article_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Content.update_article(article, @invalid_attrs)

      assert article == Content.get_article!(article.id)
    end

    test "delete_article/1 deletes the article" do
      article = article_fixture()

      assert {:ok, %Article{}} =
               Content.delete_article(article)

      assert_raise Ecto.NoResultsError, fn ->
        Content.get_article!(article.id)
      end
    end

    test "change_article/1 returns an article changeset" do
      article = article_fixture()

      assert %Ecto.Changeset{} =
               Content.change_article(article)
    end
  end
end
