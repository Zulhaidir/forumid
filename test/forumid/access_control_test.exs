defmodule Forumid.AccessControlTest do
  use Forumid.DataCase

  alias Forumid.AccessControl

  describe "user_roles" do
    alias Forumid.AccessControl.UserRole

    import Forumid.AccessControlFixtures

    @invalid_attrs %{}

    test "list_user_roles/0 returns all user_roles" do
      user_role = user_role_fixture()
      assert AccessControl.list_user_roles() == [user_role]
    end

    test "get_user_role!/1 returns the user_role with given id" do
      user_role = user_role_fixture()
      assert AccessControl.get_user_role!(user_role.id) == user_role
    end

    test "create_user_role/1 with valid data creates a user_role" do
      user = Forumid.AccountsFixtures.user_fixture()
      role = Forumid.AuthorizationFixtures.role_fixture()

      valid_attrs = %{
        user_id: user.id,
        role_id: role.id,
        assigned_at: DateTime.utc_now(:second),
        is_active: true
      }

      assert {:ok, %UserRole{} = _user_role} = AccessControl.create_user_role(valid_attrs)
    end

    test "create_user_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = AccessControl.create_user_role(@invalid_attrs)
    end

    test "update_user_role/2 with valid data updates the user_role" do
      user_role = user_role_fixture()
      update_attrs = %{is_active: false}

      assert {:ok, %UserRole{} = updated} =
               AccessControl.update_user_role(user_role, update_attrs)

      assert updated.is_active == false
    end

    test "update_user_role/2 with invalid data returns error changeset" do
      user_role = user_role_fixture()

      assert {:error, %Ecto.Changeset{}} =
               AccessControl.update_user_role(user_role, %{user_id: nil})

      assert user_role == AccessControl.get_user_role!(user_role.id)
    end

    test "delete_user_role/1 deletes the user_role" do
      user_role = user_role_fixture()
      assert {:ok, %UserRole{}} = AccessControl.delete_user_role(user_role)
      assert_raise Ecto.NoResultsError, fn -> AccessControl.get_user_role!(user_role.id) end
    end

    test "change_user_role/1 returns a user_role changeset" do
      user_role = user_role_fixture()
      assert %Ecto.Changeset{} = AccessControl.change_user_role(user_role)
    end
  end
end
