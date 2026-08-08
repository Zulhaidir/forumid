defmodule ForumidWeb.TopicLive.Show do
  use ForumidWeb, :live_view

  alias Forumid.Forum

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Topic {@topic.title}
        <:subtitle>Detail topik</:subtitle>
        <:actions>
          <.button navigate={~p"/moderation"}>
            <.icon name="hero-arrow-left" /> Back to Moderation
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Title">{@topic.title}</:item>
        <:item title="Views">{@topic.views}</:item>
        <:item title="Is pinned">{@topic.is_pinned}</:item>
        <:item title="Is locked">{@topic.is_locked}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Topic")
     |> assign(:topic, Forum.get_topic!(id))}
  end
end
