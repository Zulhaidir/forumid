defmodule Forumid.ProfilesFixtures do
  import Forumid.AccountsFixtures

  @moduledoc """
  This module defines test helpers for creating
  entities via the `Forumid.Profiles` context.
  """

  @doc """
  Generate a user_profile.
  """
  def user_profile_fixture(_attrs \\ %{}) do
    user = user_fixture()

    Forumid.Profiles.get_user_profile_by_user_id(user.id)
  end
end
