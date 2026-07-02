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
    is_active: nil
  }

  ## ---------------------------------------------------------
  ## CRUD
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

    test "create_user_profile/1 with valid attrs creates profile" do
      valid_attrs = %{
        username: "some_username",
        full_name: "Some User",
        avatar_url: "avatar.png",
        bio: "some bio",
        phone: "08123456789",
        is_active: true
      }

      assert {:ok, %UserProfile{} = profile} =
               Profiles.create_user_profile(valid_attrs)

      assert profile.username == "some_username"
      assert profile.full_name == "Some User"
      assert profile.avatar_url == "avatar.png"
      assert profile.bio == "some bio"
      assert profile.phone == "08123456789"
      assert profile.is_active == true
    end

    test "create_user_profile/1 with invalid attrs returns changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Profiles.create_user_profile(@invalid_attrs)
    end

    test "update_user_profile/2 updates profile" do
      profile = user_profile_fixture()

      attrs = %{
        username: "updated_username",
        full_name: "Updated Name",
        avatar_url: "updated.png",
        bio: "updated bio",
        phone: "08999999999",
        is_active: false
      }

      assert {:ok, %UserProfile{} = updated} =
               Profiles.update_user_profile(profile, attrs)

      assert updated.username == "updated_username"
      assert updated.full_name == "Updated Name"
      assert updated.avatar_url == "updated.png"
      assert updated.bio == "updated bio"
      assert updated.phone == "08999999999"
      assert updated.is_active == false
    end

    test "update_user_profile/2 with invalid attrs returns changeset" do
      profile = user_profile_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Profiles.update_user_profile(profile, @invalid_attrs)

      assert Profiles.get_user_profile!(profile.id) == profile
    end

    test "delete_user_profile/1 deletes profile" do
      profile = user_profile_fixture()

      assert {:ok, %UserProfile{}} =
               Profiles.delete_user_profile(profile)

      assert_raise Ecto.NoResultsError, fn ->
        Profiles.get_user_profile!(profile.id)
      end
    end
  end

  ## ---------------------------------------------------------
  ## HELPER
  ## ---------------------------------------------------------
  describe "helper" do
    test "get_user_profile_by_user_id/1 returns profile" do
      profile = user_profile_fixture()

      result =
        Profiles.get_user_profile_by_user_id(profile.user_id)

      assert result.id == profile.id
      assert result.user_id == profile.user_id
    end

    test "get_user_profile_by_username/1 returns profile" do
      profile = user_profile_fixture()

      result =
        Profiles.get_user_profile_by_username(profile.username)

      assert result.id == profile.id
      assert result.username == profile.username
    end

    test "change_user_profile/1 returns changeset" do
      profile = user_profile_fixture()

      assert %Ecto.Changeset{} =
               Profiles.change_user_profile(profile)
    end
  end

  ## ---------------------------------------------------------
  ## VALIDATION
  ## ---------------------------------------------------------
  describe "validation" do
    test "username is required" do
      assert {:error, changeset} =
               Profiles.create_user_profile(%{})

      assert "can't be blank" in errors_on(changeset).username
    end

    test "full_name is required" do
      attrs = %{
        username: "some_username"
      }

      assert {:error, changeset} =
               Profiles.create_user_profile(attrs)

      assert "can't be blank" in errors_on(changeset).full_name
    end
  end

  ## ---------------------------------------------------------
  ## UNIQUENESS
  ## ---------------------------------------------------------
  describe "uniqueness" do
    test "username must be unique" do
      profile = user_profile_fixture()

      attrs = %{
        username: profile.username,
        full_name: "Another User"
      }

      assert {:error, changeset} =
               Profiles.create_user_profile(attrs)

      assert "has already been taken" in errors_on(changeset).username
    end
  end
end
