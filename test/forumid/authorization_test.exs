defmodule Forumid.AuthorizationTest do
  use Forumid.DataCase

  alias Forumid.Authorization
  alias Forumid.Authorization.Role
  alias Forumid.Authorization.Permission

  import Forumid.AuthorizationFixtures

  @invalid_role_attrs %{
    name: nil,
    description: nil
  }

  @invalid_permission_attrs %{
    resource: nil,
    action: nil,
    description: nil
  }

  ## ---------------------------------------------------------
  ## CRUD
  ## ---------------------------------------------------------

  describe "CRUD" do
    ## ---------------- Role ----------------

    test "list_roles/0 returns all roles" do
      role = role_fixture()

      assert Authorization.list_roles() == [role]
    end

    test "get_role!/1 returns role by id" do
      role = role_fixture()

      assert Authorization.get_role!(role.id) == role
    end

    test "create_role/1 creates role" do
      attrs = %{
        name: "editor",
        description: "Editor role"
      }

      assert {:ok, %Role{} = role} =
               Authorization.create_role(attrs)

      assert role.name == "editor"
      assert role.description == "Editor role"
    end

    test "create_role/1 with invalid attrs returns changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Authorization.create_role(@invalid_role_attrs)
    end

    test "update_role/2 updates role" do
      role = role_fixture()

      attrs = %{
        name: "chief_editor",
        description: "Chief editor role"
      }

      assert {:ok, %Role{} = updated} =
               Authorization.update_role(role, attrs)

      assert updated.name == "chief_editor"
      assert updated.description == "Chief editor role"
    end

    test "update_role/2 with invalid attrs returns changeset" do
      role = role_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Authorization.update_role(role, @invalid_role_attrs)

      assert Authorization.get_role!(role.id) == role
    end

    test "delete_role/1 deletes role" do
      role = role_fixture()

      assert {:ok, %Role{}} =
               Authorization.delete_role(role)

      assert_raise Ecto.NoResultsError, fn ->
        Authorization.get_role!(role.id)
      end
    end

    ## ---------------- Permission ----------------

    test "list_permissions/0 returns all permissions" do
      permission = permission_fixture()

      assert Authorization.list_permissions() == [permission]
    end

    test "get_permission!/1 returns permission by id" do
      permission = permission_fixture()

      assert Authorization.get_permission!(permission.id) == permission
    end

    test "create_permission/1 creates permission" do
      attrs = %{
        resource: "article",
        action: "create",
        description: "Can create article"
      }

      assert {:ok, %Permission{} = permission} =
               Authorization.create_permission(attrs)

      assert permission.resource == "article"
      assert permission.action == "create"
      assert permission.description == "Can create article"
    end

    test "create_permission/1 with invalid attrs returns changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Authorization.create_permission(@invalid_permission_attrs)
    end

    test "update_permission/2 updates permission" do
      permission = permission_fixture()

      attrs = %{
        resource: "article",
        action: "publish",
        description: "Can publish article"
      }

      assert {:ok, %Permission{} = updated} =
               Authorization.update_permission(permission, attrs)

      assert updated.resource == "article"
      assert updated.action == "publish"
      assert updated.description == "Can publish article"
    end

    test "update_permission/2 with invalid attrs returns changeset" do
      permission = permission_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Authorization.update_permission(permission, @invalid_permission_attrs)

      assert Authorization.get_permission!(permission.id) == permission
    end

    test "delete_permission/1 deletes permission" do
      permission = permission_fixture()

      assert {:ok, %Permission{}} =
               Authorization.delete_permission(permission)

      assert_raise Ecto.NoResultsError, fn ->
        Authorization.get_permission!(permission.id)
      end
    end
  end

  ## ---------------------------------------------------------
  ## Helper
  ## ---------------------------------------------------------

  describe "helper" do
    test "change_role/1 returns changeset" do
      role = role_fixture()

      assert %Ecto.Changeset{} =
               Authorization.change_role(role)
    end

    test "change_permission/1 returns changeset" do
      permission = permission_fixture()

      assert %Ecto.Changeset{} =
               Authorization.change_permission(permission)
    end
  end

  ## ---------------------------------------------------------
  ## Validation
  ## ---------------------------------------------------------

  describe "validation" do
    test "role name is required" do
      assert {:error, changeset} =
               Authorization.create_role(%{})

      assert "can't be blank" in errors_on(changeset).name
    end

    test "permission resource is required" do
      assert {:error, changeset} =
               Authorization.create_permission(%{})

      assert "can't be blank" in errors_on(changeset).resource
    end

    test "permission action is required" do
      assert {:error, changeset} =
               Authorization.create_permission(%{})

      assert "can't be blank" in errors_on(changeset).action
    end
  end

  ## ---------------------------------------------------------
  ## Uniqueness
  ## ---------------------------------------------------------

  describe "uniqueness" do
    test "role name must be unique" do
      role = role_fixture()

      attrs = %{
        name: role.name,
        description: "another role"
      }

      assert {:error, changeset} =
               Authorization.create_role(attrs)

      assert "has already been taken" in errors_on(changeset).name
    end

    test "permission resource + action must be unique" do
      permission = permission_fixture()

      attrs = %{
        resource: permission.resource,
        action: permission.action,
        description: "duplicate"
      }

      assert {:error, changeset} =
               Authorization.create_permission(attrs)

      assert "has already been taken" in errors_on(changeset).resource_action
    end
  end
end
