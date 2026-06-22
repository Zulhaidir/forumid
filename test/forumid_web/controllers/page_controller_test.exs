defmodule ForumidWeb.PageControllerTest do
  use ForumidWeb.ConnCase

  test "GET /" do
    conn = build_conn()
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "ForumID"
  end
end
