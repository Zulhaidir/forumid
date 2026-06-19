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

  describe "article_media" do
    alias Forumid.Content.ArticleMedia

    import Forumid.ContentFixtures

    @invalid_attrs %{
      article_id: nil,
      media_type: nil,
      file_path: nil,
      sort_order: nil,
      caption: nil,
      alt_text: nil
    }

    test "list_article_media/0 returns all article_media" do
      article_media = article_media_fixture()
      assert Content.list_article_media() == [article_media]
    end

    test "get_article_media!/1 returns the article_media with given id" do
      article_media = article_media_fixture()
      assert Content.get_article_media!(article_media.id) == article_media
    end

    test "create_article_media/1 with valid data creates an article_media" do
      article = article_fixture()

      valid_attrs = %{
        article_id: article.id,
        media_type: "image",
        file_path: "/uploads/articles/image-1.jpg",
        sort_order: 0,
        caption: "Sample image",
        alt_text: "Sample alt text"
      }

      assert {:ok, %ArticleMedia{} = article_media} =
               Content.create_article_media(valid_attrs)

      assert article_media.article_id == article.id
      assert article_media.media_type == "image"
      assert article_media.file_path == "/uploads/articles/image-1.jpg"
      assert article_media.sort_order == 0
      assert article_media.caption == "Sample image"
      assert article_media.alt_text == "Sample alt text"
    end

    test "create_article_media/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Content.create_article_media(@invalid_attrs)
    end

    test "update_article_media/2 with valid data updates the article_media" do
      article_media = article_media_fixture()

      update_attrs = %{
        article_id: article_media.article_id,
        media_type: "video",
        file_path: "/uploads/articles/video-1.mp4",
        sort_order: 1,
        caption: "Updated caption",
        alt_text: "Updated alt text"
      }

      assert {:ok, %ArticleMedia{} = article_media} =
               Content.update_article_media(article_media, update_attrs)

      assert article_media.article_id == article_media.article_id
      assert article_media.media_type == "video"
      assert article_media.file_path == "/uploads/articles/video-1.mp4"
      assert article_media.sort_order == 1
      assert article_media.caption == "Updated caption"
      assert article_media.alt_text == "Updated alt text"
    end

    test "update_article_media/2 with invalid data returns error changeset" do
      article_media = article_media_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Content.update_article_media(article_media, @invalid_attrs)

      assert article_media ==
               Content.get_article_media!(article_media.id)
    end

    test "delete_article_media/1 deletes the article_media" do
      article_media = article_media_fixture()

      assert {:ok, %ArticleMedia{}} =
               Content.delete_article_media(article_media)

      assert_raise Ecto.NoResultsError, fn ->
        Content.get_article_media!(article_media.id)
      end
    end

    test "change_article_media/1 returns an article_media changeset" do
      article_media = article_media_fixture()

      assert %Ecto.Changeset{} =
               Content.change_article_media(article_media)
    end
  end
end
