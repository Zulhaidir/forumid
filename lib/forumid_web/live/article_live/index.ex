defmodule ForumidWeb.ArticleLive.Index do
  use ForumidWeb, :live_view

  alias Forumid.Content

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_scope.user
    articles = Content.list_articles_by_user(user.id)

    {:ok, stream(socket, :articles, articles)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        My Articles
        <:actions>
          <.button variant="primary" navigate={~p"/articles/new"}>
            New Article
          </.button>
        </:actions>
      </.header>

      <.table id="articles" rows={@streams.articles}>
        <:col :let={{_id, article}} label="Title">
          <.link navigate={~p"/articles/#{article.slug}/edit"}>{article.title}</.link>
        </:col>
        <:col :let={{_id, article}} label="Status">
          {article.status}
        </:col>
        <:col :let={{_id, article}} label="Actions">
          <.link navigate={~p"/articles/#{article.slug}/edit"}>Edit</.link>
        </:col>
      </.table>
    </Layouts.app>
    """
  end
end
