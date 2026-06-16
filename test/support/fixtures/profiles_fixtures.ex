defmodule Forumid.ProfilesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Forumid.Profiles` context.
  """

  @doc """
  Generate a user_profile.
  """
  def user_profile_fixture(attrs \\ %{}) do
    {:ok, user_profile} =
      attrs
      |> Enum.into(%{
        avatar_url: "some avatar_url",
        bio: "some bio",
        full_name: "some full_name",
        is_active: true,
        phone: "some phone",
        username: "some username"
      })
      |> Forumid.Profiles.create_user_profile()

    user_profile
  end
end
