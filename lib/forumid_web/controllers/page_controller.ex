defmodule ForumidWeb.PageController do
  use ForumidWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
