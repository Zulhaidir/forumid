defmodule ForumidWeb.PageController do
  use ForumidWeb, :controller
  alias Forumid.Content

  def home(conn, _params) do
    articles = Content.list_published_articles()

    render(conn, :home, articles: articles)
  end
end
