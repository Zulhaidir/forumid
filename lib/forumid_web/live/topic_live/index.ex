defmodule ForumidWeb.TopicLive.Index do
  use ForumidWeb, :live_view

  alias Forumid.Forum
  # alias Forumid.Audit

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Moderation Tools
        <:subtitle>Kelola topik forum di sini</:subtitle>
      </.header>

      <.table id="topics" rows={@streams.topics}>
        <:col :let={{_id, topic}} label="Title">
          {topic.title}
          <%= if topic.is_pinned do %>
            <span class="badge badge-primary badge-sm ml-2">Pinned</span>
          <% end %>
          <%= if topic.is_locked do %>
            <span class="badge badge-error badge-sm ml-2">Locked</span>
          <% end %>
        </:col>
        <:col :let={{_id, topic}} label="Views">
          {topic.views}
        </:col>
        <:action :let={{_id, topic}}>
          <.button phx-click="toggle_pin" phx-value-id={topic.id}>
            {if topic.is_pinned, do: "Unpin", else: "Pin"}
          </.button>
        </:action>
        <:action :let={{_id, topic}}>
          <.button phx-click="toggle_lock" phx-value-id={topic.id}>
            {if topic.is_locked, do: "Unlock", else: "Lock"}
          </.button>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Moderation Tools")
     |> stream(:topics, Forum.list_topics())}
  end

  @impl true
  def handle_event("toggle_pin", %{"id" => id}, socket) do
    topic = Forum.get_topic!(id)
    new_status = !topic.is_pinned

    case Forum.update_topic(topic, %{is_pinned: new_status}) do
      {:ok, updated_topic} ->
        log_action(
          socket,
          "update_pin",
          "topic",
          topic.id,
          "Topik '#{topic.title}' #{if new_status, do: "di-pin", else: "di-unpin"}"
        )

        {:noreply, stream_insert(socket, :topics, updated_topic)}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Gagal mengubah status pin.")}
    end
  end

  def handle_event("toggle_lock", %{"id" => id}, socket) do
    topic = Forum.get_topic!(id)
    new_status = !topic.is_locked

    case Forum.update_topic(topic, %{is_locked: new_status}) do
      {:ok, updated_topic} ->
        log_action(
          socket,
          "update_lock",
          "topic",
          topic.id,
          "Topik '#{topic.title}' #{if new_status, do: "di-kunci", else: "di-buka"}"
        )

        {:noreply, stream_insert(socket, :topics, updated_topic)}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Gagal mengubah status lock.")}
    end
  end

  defp log_action(socket, action, resource, resource_id, description) do
    user_id = socket.assigns.current_scope.user.id

    Forumid.Audit.create_activity_log(%{
      action: action,
      resource: resource,
      resource_id: resource_id,
      description: description,
      user_id: user_id
    })
  end
end
