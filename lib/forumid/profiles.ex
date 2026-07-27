defmodule Forumid.Profiles do
  import Ecto.Query, warn: false
  alias Forumid.Authorization
  alias Forumid.Repo
  alias Forumid.Profiles.UserProfile

  ## -----------------------------------------
  ## User Profile
  ## -----------------------------------------

  ## LIST
  def list_user_profiles do
    Repo.all(UserProfile)
  end

  ## CREATE
  def create_user_profile(attrs \\ %{}) do
    %UserProfile{}
    |> UserProfile.changeset(attrs)
    |> Repo.insert()
  end

  ## UPDATE
  def update_user_profile(%UserProfile{} = user_profile, attrs) do
    user_profile
    |> UserProfile.changeset(attrs)
    |> Repo.update(
      stale_error_field: :lock_version,
      stale_error_message: "profil ini sudah diubah, silakan muat ulang data terbaru"
    )
  end

  ## CHANGESET
  def change_user_profile(%UserProfile{} = user_profile, attrs \\ %{}) do
    UserProfile.changeset(user_profile, attrs)
  end

  ## -----------------------------------------
  ##  Helper
  ## -----------------------------------------

  ## GET (by id)
  def get_user_profile!(id), do: Repo.get!(UserProfile, id)

  ## GET (by user_id)
  def get_user_profile_by_user_id(user_id) do
    Repo.get_by(UserProfile, user_id: user_id)
  end

  ## GET (by username)
  def get_user_profile_by_username(username) do
    Repo.get_by(UserProfile, username: username)
  end

  ## Suspend
  def suspend_user(admin, %UserProfile{} = target_profile, reason \\ "suspended") do
    if Authorization.can?(admin, "users", "suspend") do
      target_profile
      |> UserProfile.status_changeset(%{status: reason})
      |> Repo.update(
        stale_error_field: :lock_version,
        stale_error_message:
          "profil ini sudah diubah di tempat lain, silakan muat ulang data terbaru"
      )
    else
      {:error, :unauthorized}
    end
  end

  def unsuspend_user(admin, %UserProfile{} = target_profile) do
    if Authorization.can?(admin, "users", "suspend") do
      target_profile
      |> UserProfile.status_changeset(%{status: "active"})
      |> Repo.update(stale_error_field: :lock_version)
    else
      {:error, :unauthorized}
    end
  end
end
