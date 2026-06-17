defmodule ForumidWeb.ProfileLive.Edit do
  use ForumidWeb, :live_view
  alias Forumid.Profiles

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_scope.user
    profile = Profiles.get_user_profile_by_user_id(user.id)
    changeset = Profiles.change_user_profile(profile)

    {:ok,
     socket
     |> assign(:profile, profile)
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="max-w-2xl mx-auto p-6">
        <.header>
          Edit Profile
          <:subtitle>Update your public profile information</:subtitle>
        </.header>

        <.form for={@form} phx-change="validate" phx-submit="save" class="space-y-4 mt-6">
          <.input field={@form[:full_name]} label="Full Name" />
          <.input field={@form[:username]} label="Username" />
          <.input field={@form[:bio]} type="textarea" label="Bio" />
          <.input field={@form[:phone]} label="Phone" />

          <.button type="submit" variant="primary" phx-disable-with="Saving...">
            Save Profile
          </.button>
        </.form>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def handle_event("validate", %{"user_profile" => params}, socket) do
    changeset =
      socket.assigns.profile
      |> Profiles.change_user_profile(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  @impl true
  def handle_event("save", %{"user_profile" => params}, socket) do
    case Profiles.update_user_profile(socket.assigns.profile, params) do
      {:ok, _profile} ->
        {:noreply,
         socket
         |> put_flash(:info, "Profile updated successfully")
         |> push_navigate(to: ~p"/")}

      {:error, changeset} ->
        {:noreply,
         socket
         |> assign(:form, to_form(changeset))
         |> put_flash(:error, "Failed to update profile")}
    end
  end
end
