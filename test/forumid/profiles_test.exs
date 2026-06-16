defmodule Forumid.ProfilesTest do
  use Forumid.DataCase

  alias Forumid.Profiles

  describe "user_profiles" do
    alias Forumid.Profiles.UserProfile

    import Forumid.ProfilesFixtures

    @invalid_attrs %{username: nil, full_name: nil, avatar_url: nil, bio: nil, phone: nil, is_active: nil}

    test "list_user_profiles/0 returns all user_profiles" do
      user_profile = user_profile_fixture()
      assert Profiles.list_user_profiles() == [user_profile]
    end

    test "get_user_profile!/1 returns the user_profile with given id" do
      user_profile = user_profile_fixture()
      assert Profiles.get_user_profile!(user_profile.id) == user_profile
    end

    test "create_user_profile/1 with valid data creates a user_profile" do
      valid_attrs = %{username: "some username", full_name: "some full_name", avatar_url: "some avatar_url", bio: "some bio", phone: "some phone", is_active: true}

      assert {:ok, %UserProfile{} = user_profile} = Profiles.create_user_profile(valid_attrs)
      assert user_profile.username == "some username"
      assert user_profile.full_name == "some full_name"
      assert user_profile.avatar_url == "some avatar_url"
      assert user_profile.bio == "some bio"
      assert user_profile.phone == "some phone"
      assert user_profile.is_active == true
    end

    test "create_user_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Profiles.create_user_profile(@invalid_attrs)
    end

    test "update_user_profile/2 with valid data updates the user_profile" do
      user_profile = user_profile_fixture()
      update_attrs = %{username: "some updated username", full_name: "some updated full_name", avatar_url: "some updated avatar_url", bio: "some updated bio", phone: "some updated phone", is_active: false}

      assert {:ok, %UserProfile{} = user_profile} = Profiles.update_user_profile(user_profile, update_attrs)
      assert user_profile.username == "some updated username"
      assert user_profile.full_name == "some updated full_name"
      assert user_profile.avatar_url == "some updated avatar_url"
      assert user_profile.bio == "some updated bio"
      assert user_profile.phone == "some updated phone"
      assert user_profile.is_active == false
    end

    test "update_user_profile/2 with invalid data returns error changeset" do
      user_profile = user_profile_fixture()
      assert {:error, %Ecto.Changeset{}} = Profiles.update_user_profile(user_profile, @invalid_attrs)
      assert user_profile == Profiles.get_user_profile!(user_profile.id)
    end

    test "delete_user_profile/1 deletes the user_profile" do
      user_profile = user_profile_fixture()
      assert {:ok, %UserProfile{}} = Profiles.delete_user_profile(user_profile)
      assert_raise Ecto.NoResultsError, fn -> Profiles.get_user_profile!(user_profile.id) end
    end

    test "change_user_profile/1 returns a user_profile changeset" do
      user_profile = user_profile_fixture()
      assert %Ecto.Changeset{} = Profiles.change_user_profile(user_profile)
    end
  end
end
