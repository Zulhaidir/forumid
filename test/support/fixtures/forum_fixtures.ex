defmodule Forumid.ForumFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Forumid.Forum` context.
  """

  import Forumid.AccountsFixtures

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    user = user_fixture()

    attrs =
      Enum.into(attrs, %{
        description: "some description",
        name: "some name",
        slug: "some slug",
        user_id: user.id
      })

    {:ok, category} = Forumid.Forum.create_category(attrs)
    category
  end

  @doc """
  Generate a tag.
  """
  def tag_fixture(attrs \\ %{}) do
    {:ok, tag} =
      attrs
      |> Enum.into(%{
        name: "some name",
        slug: "some slug"
      })
      |> Forumid.Forum.create_tag()

    tag
  end

  @doc """
  Generate a topic.
  """
  def topic_fixture(attrs \\ %{}) do
    user = user_fixture()
    category = category_fixture(%{user_id: user.id})

    attrs =
      Enum.into(attrs, %{
        body: "some body content for testing",
        slug: "some-slug-#{System.unique_integer()}",
        title: "some title",
        category_id: category.id,
        user_id: user.id
      })

    {:ok, topic} = Forumid.Forum.create_topic(attrs)
    topic
  end

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    user = user_fixture()
    topic = topic_fixture(%{user_id: user.id})

    attrs =
      Enum.into(attrs, %{
        body: "some body",
        topic_id: topic.id,
        user_id: user.id
      })

    {:ok, post} = Forumid.Forum.create_post(attrs)
    post
  end
end
