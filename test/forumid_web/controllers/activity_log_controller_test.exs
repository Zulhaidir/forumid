defmodule ForumidWeb.ActivityLogControllerTest do
  use ForumidWeb.ConnCase

  import Forumid.AuditFixtures

  setup :register_and_log_in_user

  describe "index" do
    test "lists all activity_logs", %{conn: conn} do
      conn = get(conn, ~p"/moderation/activity_logs")
      assert html_response(conn, 200) =~ "Activity Logs"
    end
  end

  describe "show activity_log" do
    setup [:create_activity_log]

    test "renders activity_log details", %{conn: conn, activity_log: activity_log} do
      conn = get(conn, ~p"/moderation/activity_logs/#{activity_log}")
      assert html_response(conn, 200) =~ activity_log.action
    end
  end

  defp create_activity_log(_) do
    activity_log = activity_log_fixture()
    %{activity_log: activity_log}
  end
end
