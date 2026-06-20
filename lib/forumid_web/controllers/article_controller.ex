defmodule ForumidWeb.ArticleController do
  use ForumidWeb, :controller

  alias Forumid.Content

  def show(conn, %{"slug" => slug}) do
    article =
      Content.article_by_slug!(slug)

    render(conn, :show, article: article)
  end
end
