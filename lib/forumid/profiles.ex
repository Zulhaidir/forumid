defmodule Forumid.Profiles do
  import Ecto.Query, warn: false
  alias Forumid.Repo
  alias Forumid.Profiles.UserProfile

  ## LIST
  def list_user_profiles do
    Repo.all(UserProfile)
  end

  ## GET BY ID
  def get_user_profile!(id), do: Repo.get!(UserProfile, id)

  ## GET BY USER ID
  def get_user_profile_by_user_id(user_id) do
    Repo.get_by(UserProfile, user_id: user_id)
  end

  ## GET BY USERNAME
  def get_user_profile_by_username(username) do
    Repo.get_by(UserProfile, username: username)
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
    |> Repo.update()
  end

  ## DELETE
  def delete_user_profile(%UserProfile{} = user_profile) do
    Repo.delete(user_profile)
  end

  ## CHANGESET (FIXED)
  def change_user_profile(%UserProfile{} = user_profile, attrs \\ %{}) do
    UserProfile.changeset(user_profile, attrs)
  end
end
