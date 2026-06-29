defmodule Forumid.AccessControl do
  @moduledoc """
  The AccessControl context.
  """

  import Ecto.Query, warn: false
  alias Forumid.Repo

  alias Forumid.AccessControl.UserRole
  alias Forumid.AccessControl.RolePermission

  ## -----------------------------------------
  ## User Role
  ## -----------------------------------------

  ## LIST
  def list_user_roles do
    Repo.all(UserRole)
  end

  ## GET
  def get_user_role!(id), do: Repo.get!(UserRole, id)

  ## CREATE
  def create_user_role(attrs) do
    %UserRole{}
    |> UserRole.changeset(attrs)
    |> Repo.insert()
  end

  ## UPDATE
  def update_user_role(%UserRole{} = user_role, attrs) do
    user_role
    |> UserRole.changeset(attrs)
    |> Repo.update()
  end

  ## DELETE
  def delete_user_role(%UserRole{} = user_role) do
    Repo.delete(user_role)
  end

  ## CHANGE
  def change_user_role(%UserRole{} = user_role, attrs \\ %{}) do
    UserRole.changeset(user_role, attrs)
  end

  ## -----------------------------------------
  ## Role Permission
  ## -----------------------------------------

  # LIST
  def list_role_permissions do
    Repo.all(RolePermission)
  end

  # GET
  def get_role_permission!(id), do: Repo.get!(RolePermission, id)

  # CREATE
  def create_role_permission(attrs) do
    %RolePermission{}
    |> RolePermission.changeset(attrs)
    |> Repo.insert()
  end

  # UPDATE
  def update_role_permission(%RolePermission{} = role_permission, attrs) do
    role_permission
    |> RolePermission.changeset(attrs)
    |> Repo.update()
  end

  # DELETE
  def delete_role_permission(%RolePermission{} = role_permission) do
    Repo.delete(role_permission)
  end

  # CHANGE
  def change_role_permission(%RolePermission{} = role_permission, attrs \\ %{}) do
    RolePermission.changeset(role_permission, attrs)
  end
end
