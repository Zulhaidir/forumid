defmodule ForumidWeb.TopicLiveTest do
  use ForumidWeb.ConnCase

  import Phoenix.LiveViewTest
  import Forumid.ForumFixtures

  setup :register_and_log_in_user

  setup %{user: user} do
    {:ok, role} = Forumid.Authorization.create_role(%{name: "moderator_test"})

    {:ok, permission} =
      Forumid.Authorization.create_permission(%{resource: "forum", action: "update"})

    Forumid.AccessControl.assign_permission(role.id, permission.id)
    Forumid.AccessControl.assign_role(user.id, role.id)

    :ok
  end

  defp create_topic(_) do
    topic = topic_fixture()
    %{topic: topic}
  end

  describe "Index" do
    setup [:create_topic]

    test "lists all topics in moderation", %{conn: conn, topic: topic} do
      {:ok, _index_live, html} = live(conn, ~p"/moderation")

      assert html =~ "Moderation Tools"
      assert html =~ topic.title
    end
  end

  describe "Show" do
    setup [:create_topic]

    test "displays topic", %{conn: conn, topic: topic} do
      {:ok, _show_live, html} = live(conn, ~p"/moderation/topics/#{topic}")

      assert html =~ "Show Topic"
      assert html =~ topic.title
    end
  end
end
