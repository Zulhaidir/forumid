defmodule Forumid.ForumTest do
  use Forumid.DataCase

  alias Forumid.Forum

  import Forumid.AccountsFixtures
  import Forumid.ForumFixtures

  describe "categories" do
    alias Forumid.Forum.Category

    @invalid_attrs %{name: nil, description: nil, slug: nil}

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Forum.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Forum.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      user = user_fixture()

      valid_attrs = %{
        name: "some name",
        description: "some description",
        slug: "some slug",
        user_id: user.id
      }

      assert {:ok, %Category{} = category} = Forum.create_category(valid_attrs)
      assert category.name == "some name"
      assert category.description == "some description"
      assert category.slug == "some slug"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forum.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()

      update_attrs = %{
        name: "some updated name",
        description: "some updated description",
        slug: "some updated slug"
      }

      assert {:ok, %Category{} = category} = Forum.update_category(category, update_attrs)
      assert category.name == "some updated name"
      assert category.description == "some updated description"
      assert category.slug == "some updated slug"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Forum.update_category(category, @invalid_attrs)
      assert category == Forum.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Forum.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Forum.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Forum.change_category(category)
    end
  end

  describe "tags" do
    alias Forumid.Forum.Tag

    @invalid_attrs %{name: nil, slug: nil}

    test "list_tags/0 returns all tags" do
      tag = tag_fixture()
      assert Forum.list_tags() == [tag]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = tag_fixture()
      assert Forum.get_tag!(tag.id) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      valid_attrs = %{name: "some name", slug: "some slug"}

      assert {:ok, %Tag{} = tag} = Forum.create_tag(valid_attrs)
      assert tag.name == "some name"
      assert tag.slug == "some slug"
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forum.create_tag(@invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()
      update_attrs = %{name: "some updated name", slug: "some updated slug"}

      assert {:ok, %Tag{} = tag} = Forum.update_tag(tag, update_attrs)
      assert tag.name == "some updated name"
      assert tag.slug == "some updated slug"
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Forum.update_tag(tag, @invalid_attrs)
      assert tag == Forum.get_tag!(tag.id)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Forum.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Forum.get_tag!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Forum.change_tag(tag)
    end
  end

  describe "topics" do
    alias Forumid.Forum.Topic

    @invalid_attrs %{
      title: nil,
      body: nil,
      slug: nil,
      views: nil,
      is_pinned: nil,
      is_locked: nil
    }

    test "list_topics/0 returns all topics" do
      topic = topic_fixture()
      assert Forum.list_topics() == [topic]
    end

    test "get_topic!/1 returns the topic with given id" do
      topic = topic_fixture()
      assert Forum.get_topic!(topic.id) == topic
    end

    test "create_topic/1 with valid data creates a topic" do
      user = user_fixture()
      category = category_fixture(%{user_id: user.id})

      valid_attrs = %{
        title: "some title",
        body: "some body content for testing",
        slug: "some slug",
        views: 42,
        is_pinned: true,
        is_locked: true,
        category_id: category.id,
        user_id: user.id
      }

      assert {:ok, %Topic{} = topic} = Forum.create_topic(valid_attrs)
      assert topic.title == "some title"
      assert topic.body == "some body content for testing"
      assert topic.slug == "some slug"
      assert topic.views == 42
      assert topic.is_pinned == true
      assert topic.is_locked == true
    end

    test "create_topic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forum.create_topic(@invalid_attrs)
    end

    test "update_topic/2 with valid data updates the topic" do
      topic = topic_fixture()

      update_attrs = %{
        title: "some updated title",
        body: "some updated body",
        slug: "some updated slug",
        views: 43,
        is_pinned: false,
        is_locked: false
      }

      assert {:ok, %Topic{} = topic} = Forum.update_topic(topic, update_attrs)
      assert topic.title == "some updated title"
      assert topic.body == "some updated body"
      assert topic.slug == "some updated slug"
      assert topic.views == 43
      assert topic.is_pinned == false
      assert topic.is_locked == false
    end

    test "update_topic/2 with invalid data returns error changeset" do
      topic = topic_fixture()
      assert {:error, %Ecto.Changeset{}} = Forum.update_topic(topic, @invalid_attrs)
      assert topic == Forum.get_topic!(topic.id)
    end

    test "delete_topic/1 deletes the topic" do
      topic = topic_fixture()
      assert {:ok, %Topic{}} = Forum.delete_topic(topic)
      assert_raise Ecto.NoResultsError, fn -> Forum.get_topic!(topic.id) end
    end

    test "change_topic/1 returns a topic changeset" do
      topic = topic_fixture()
      assert %Ecto.Changeset{} = Forum.change_topic(topic)
    end
  end

  describe "posts" do
    alias Forumid.Forum.Post

    @invalid_attrs %{body: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Forum.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Forum.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      user = user_fixture()
      topic = topic_fixture(%{user_id: user.id})

      valid_attrs = %{
        body: "some body",
        user_id: user.id,
        topic_id: topic.id
      }

      assert {:ok, %Post{} = post} = Forum.create_post(valid_attrs)
      assert post.body == "some body"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forum.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{body: "some updated body"}

      assert {:ok, %Post{} = post} = Forum.update_post(post, update_attrs)
      assert post.body == "some updated body"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Forum.update_post(post, @invalid_attrs)
      assert post == Forum.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Forum.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Forum.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Forum.change_post(post)
    end
  end
end
