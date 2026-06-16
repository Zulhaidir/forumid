defmodule ForumidWeb.ProfileLive.Show do
  use ForumidWeb, :live_view

  alias Forumid.Profiles

  @impl true
  def mount(%{"username" => username}, _session, socket) do
    profile = Profiles.get_user_profile_by_username(username)

    {:ok,
     socket
     |> assign(:profile, profile)
     |> assign(:username, username)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-2xl mx-auto p-6">
      <%= if @profile do %>
        <h1 class="text-2xl font-bold">
          {@profile.full_name || @profile.username}
        </h1>

        <p class="text-gray-500">
          @{@profile.username}
        </p>

        <div class="mt-4">
          <p>{@profile.bio || "No bio yet"}</p>
        </div>
      <% else %>
        <h1 class="text-xl font-bold">User not found</h1>
      <% end %>
    </div>
    """
  end
end
