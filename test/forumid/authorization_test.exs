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

  describe "permissions" do
    alias Forumid.Authorization.Permission
    import Forumid.AuthorizationFixtures

    @invalid_attrs %{resource: nil, action: nil}

    test "list_permissions/0 returns all permissions" do
      permission = permission_fixture()
      assert Authorization.list_permissions() == [permission]
    end

    test "get_permission!/1 returns the permission with given id" do
      permission = permission_fixture()
      assert Authorization.get_permission!(permission.id) == permission
    end

    test "create_permission/1 with valid data creates a permission" do
      valid_attrs = %{
        resource: "article",
        action: "create",
        description: "Can create article"
      }

      assert {:ok, %Permission{} = permission} = Authorization.create_permission(valid_attrs)
      assert permission.resource == "article"
      assert permission.action == "create"
      assert permission.description == "Can create article"
    end

    test "create_permission/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Authorization.create_permission(@invalid_attrs)
    end

    test "update_permission/2 with valid data updates the permission" do
      permission = permission_fixture()

      update_attrs = %{
        resource: "article",
        action: "publish",
        description: "Can publish article"
      }

      assert {:ok, %Permission{} = permission} =
               Authorization.update_permission(permission, update_attrs)

      assert permission.resource == "article"
      assert permission.action == "publish"
      assert permission.description == "Can publish article"
    end

    test "update_permission/2 with invalid data returns error changeset" do
      permission = permission_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Authorization.update_permission(permission, @invalid_attrs)

      assert permission == Authorization.get_permission!(permission.id)
    end

    test "delete_permission/1 deletes the permission" do
      permission = permission_fixture()
      assert {:ok, %Permission{}} = Authorization.delete_permission(permission)
      assert_raise Ecto.NoResultsError, fn -> Authorization.get_permission!(permission.id) end
    end

    test "change_permission/1 returns a permission changeset" do
      permission = permission_fixture()
      assert %Ecto.Changeset{} = Authorization.change_permission(permission)
    end
  end
end
