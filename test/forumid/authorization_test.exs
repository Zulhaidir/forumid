defmodule Forumid.AuthorizationTest do
  use Forumid.DataCase

  alias Forumid.Authorization

  describe "roles" do
    alias Forumid.Authorization.Role
    import Forumid.AuthorizationFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_roles/0 returns all roles" do
      role = role_fixture()
      assert Authorization.list_roles() == [role]
    end

    test "get_role!/1 returns the role with given id" do
      role = role_fixture()
      assert Authorization.get_role!(role.id) == role
    end

    test "create_role/1 with valid data creates a role" do
      valid_attrs = %{name: "editor", description: "Editor role"}

      assert {:ok, %Role{} = role} = Authorization.create_role(valid_attrs)
      assert role.name == "editor"
      assert role.description == "Editor role"
    end

    test "create_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Authorization.create_role(@invalid_attrs)
    end

    test "update_role/2 with valid data updates the role" do
      role = role_fixture()
      update_attrs = %{name: "chief_editor", description: "Chief editor role"}

      assert {:ok, %Role{} = role} = Authorization.update_role(role, update_attrs)
      assert role.name == "chief_editor"
      assert role.description == "Chief editor role"
    end

    test "update_role/2 with invalid data returns error changeset" do
      role = role_fixture()
      assert {:error, %Ecto.Changeset{}} = Authorization.update_role(role, @invalid_attrs)
      assert role == Authorization.get_role!(role.id)
    end

    test "delete_role/1 deletes the role" do
      role = role_fixture()
      assert {:ok, %Role{}} = Authorization.delete_role(role)
      assert_raise Ecto.NoResultsError, fn -> Authorization.get_role!(role.id) end
    end

    test "change_role/1 returns a role changeset" do
      role = role_fixture()
      assert %Ecto.Changeset{} = Authorization.change_role(role)
    end
  end
end
