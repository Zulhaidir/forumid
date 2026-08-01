defmodule Forumid.ProfilesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Forumid.Profiles` context.
  """

  alias Forumid.Accounts
  alias Forumid.Profiles

  import Forumid.AccountsFixtures, only: [unique_user_email: 0]

  @doc """
  Generate a user_profile.

  Creates a real user (via Accounts.register_user/1, which also
  creates the associated user_profile), then applies any custom
  attrs on top via Profiles.update_user_profile/2.
  """
  def user_profile_fixture(attrs \\ %{}) do
    {:ok, user} = Accounts.register_user(%{email: unique_user_email()})

    profile = Profiles.get_user_profile_by_user_id(user.id)

    default_attrs = %{
      full_name: "Some User",
      avatar_url: "avatar.png",
      bio: "some bio",
      phone: "08123456789",
      status: "active",
      onboarding_status: "draft"
    }

    merged_attrs = Enum.into(attrs, default_attrs)

    {:ok, user_profile} = Profiles.update_user_profile(profile, merged_attrs)

    user_profile
  end
end
