defmodule ForumidWeb.ActivityLogController do
  use ForumidWeb, :controller

  alias Forumid.Audit

  def index(conn, _params) do
    activity_logs = Audit.list_activity_logs()
    render(conn, :index, activity_logs: activity_logs)
  end

  def show(conn, %{"id" => id}) do
    activity_log = Audit.get_activity_log!(id)
    render(conn, :show, activity_log: activity_log)
  end
end
