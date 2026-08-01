defmodule Forumid.ProfilesTest do
  use Forumid.DataCase

  alias Forumid.Profiles
  alias Forumid.Profiles.UserProfile

  import Forumid.ProfilesFixtures

  @invalid_attrs %{
    username: nil,
    full_name: nil,
    avatar_url: nil,
    bio: nil,
    phone: nil,
    status: nil,
    onboarding_status: nil
  }

  ## ---------------------------------------------------------
  ## CRUD (Read & Update — create/delete dimiliki Accounts)
  ## ---------------------------------------------------------
  describe "CRUD" do
    test "list_user_profiles/0 returns all profiles" do
      profile = user_profile_fixture()

      assert Profiles.list_user_profiles() == [profile]
    end

    test "get_user_profile!/1 returns profile by id" do
      profile = user_profile_fixture()

      assert Profiles.get_user_profile!(profile.id) == profile
    end

    test "update_user_profile/2 updates profile" do
      profile = user_profile_fixture()

      attrs = %{
        username: "updated_username",
        full_name: "Updated Name",
        avatar_url: "updated.png",
        bio: "updated bio",
        phone: "08999999999",
        onboarding_status: "complete",
        status: "inactive"
      }

      assert {:ok, %UserProfile{} = updated} =
               Profiles.update_user_profile(profile, attrs)

      assert updated.username == "updated_username"
      assert updated.full_name == "Updated Name"
      assert updated.avatar_url == "updated.png"
      assert updated.bio == "updated bio"
      assert updated.phone == "08999999999"
      assert updated.onboarding_status == "complete"
      assert updated.status == "inactive"
    end

    test "update_user_profile/2 with invalid attrs returns changeset" do
      profile = user_profile_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Profiles.update_user_profile(profile, @invalid_attrs)

      assert Profiles.get_user_profile!(profile.id) == profile
    end
  end

  ## ---------------------------------------------------------
  ## HELPER
  ## ---------------------------------------------------------
  describe "helper" do
    test "get_user_profile_by_user_id/1 returns profile" do
      profile = user_profile_fixture()

      result = Profiles.get_user_profile_by_user_id(profile.user_id)

      assert result.id == profile.id
      assert result.user_id == profile.user_id
    end

    test "get_user_profile_by_username/1 returns profile" do
      profile = user_profile_fixture()

      result = Profiles.get_user_profile_by_username(profile.username)

      assert result.id == profile.id
      assert result.username == profile.username
    end

    test "change_user_profile/1 returns changeset" do
      profile = user_profile_fixture()

      assert %Ecto.Changeset{} = Profiles.change_user_profile(profile)
    end
  end

  ## ---------------------------------------------------------
  ## VALIDATION (Schema — diuji langsung ke UserProfile.changeset/2)
  ## ---------------------------------------------------------
  describe "validation" do
    test "username is required" do
      changeset = UserProfile.changeset(%UserProfile{}, %{full_name: "Some User"})

      assert "can't be blank" in errors_on(changeset).username
    end

    test "full_name is required" do
      changeset = UserProfile.changeset(%UserProfile{}, %{username: "some_username"})

      assert "can't be blank" in errors_on(changeset).full_name
    end

    test "status must be a valid inclusion" do
      changeset =
        UserProfile.changeset(%UserProfile{}, %{
          username: "some_username",
          full_name: "Some User",
          status: "not_a_real_status"
        })

      assert "is invalid" in errors_on(changeset).status
    end

    test "onboarding_status must be a valid inclusion" do
      changeset =
        UserProfile.changeset(%UserProfile{}, %{
          username: "some_username",
          full_name: "Some User",
          onboarding_status: "not_a_real_status"
        })

      assert "is invalid" in errors_on(changeset).onboarding_status
    end
  end

  ## ---------------------------------------------------------
  ## UNIQUENESS
  ## ---------------------------------------------------------
  describe "uniqueness" do
    test "username must be unique" do
      profile_1 = user_profile_fixture()
      profile_2 = user_profile_fixture()

      assert {:error, changeset} =
               Profiles.update_user_profile(profile_2, %{username: profile_1.username})

      assert "has already been taken" in errors_on(changeset).username
    end
  end
end
