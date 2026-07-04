defmodule Forumid.AccessControl do
  @moduledoc """
  The AccessControl context.
  """

  import Ecto.Query, warn: false
  alias Forumid.Repo

  alias Forumid.AccessControl.UserRole
  alias Forumid.AccessControl.RolePermission

  ## =========================================
  ## User Role
  ## =========================================

  ## ----------------- CRUD ------------------
  ## LIST
  def list_user_roles, do: Repo.all(UserRole)

  ## GET
  def get_user_role!(id), do: Repo.get!(UserRole, id)

  ## CREATE
  def create_user_role(attrs \\ %{}) do
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

  ## --------------- Helper ------------------
  ## Lookup
  def get_user_role(user_id, role_id) do
    Repo.get_by(UserRole, user_id: user_id, role_id: role_id)
  end

  def get_active_user_role(user_id, role_id) do
    Repo.get_by(UserRole, user_id: user_id, role_id: role_id, is_active: true)
  end

  def get_user_primary_role(user_id) do
    Repo.get_by(UserRole, user_id: user_id, is_primary: true)
  end

  ## Exist
  def user_has_role?(user_id, role_id) do
    Repo.exists?(from ur in UserRole, where: ur.user_id == ^user_id and ur.role_id == ^role_id)
  end

  def user_has_any_role?(user_id) do
    Repo.exists?(from ur in UserRole, where: ur.user_id == ^user_id)
  end

  ## Count
  def count_role_users(role_id) do
    UserRole
    |> where([ur], ur.role_id == ^role_id and ur.is_active == true)
    |> Repo.aggregate(:count, :id)
  end

  ## List
  def list_role_users(role_id) do
    UserRole
    |> where([ur], ur.role_id == ^role_id and ur.is_active == true)
    |> Repo.all()
  end

  ## ----------- Validation Helper -----------
  ## Validation

  ## Availability
  def user_role_available?(user_id, role_id) do
    not Repo.exists?(
      from ur in UserRole, where: ur.user_id == ^user_id and ur.role_id == ^role_id
    )
  end

  ## Integrity checking

  ## ----------- Business Helper -------------
  ## Business Rule
  def role_in_use?(role_id) do
    count_role_users(role_id) > 0
  end

  ## Ecto.Multi
  ## Multi Agregate

  ## Domain Operation
  def assign_role(user_id, role_id, is_primary \\ false) do
    %UserRole{}
    |> UserRole.changeset(%{
      user_id: user_id,
      role_id: role_id,
      is_active: true,
      is_primary: is_primary
    })
    |> Repo.insert()
  end

  def revoke_role(user_id, role_id) do
    case get_user_role(user_id, role_id) do
      nil -> {:error, :not_found}
      %UserRole{} = user_role -> Repo.delete(user_role)
    end
  end

  def activate_role(user_id, role_id) do
    case get_user_role(user_id, role_id) do
      nil ->
        {:error, :not_found}

      %UserRole{} = user_role ->
        user_role
        |> UserRole.changeset(%{is_active: true})
        |> Repo.update()
    end
  end

  def deactivate_role(user_id, role_id) do
    case get_user_role(user_id, role_id) do
      nil ->
        {:error, :not_found}

      %UserRole{} = user_role ->
        user_role
        |> UserRole.changeset(%{is_active: false})
        |> Repo.update()
    end
  end

  ## =========================================
  ## Role Permission
  ## =========================================

  ## ----------------- CRUD ------------------
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

  ## --------------- Helper ------------------
  ## Lookup
  def get_role_permission(role_id, permission_id) do
    Repo.get_by(RolePermission, role_id: role_id, permission_id: permission_id)
  end

  ## Exist
  def role_has_permission?(role_id, permission_id) do
    Repo.exists?(
      from rp in RolePermission,
        where: rp.role_id == ^role_id and rp.permission_id == ^permission_id
    )
  end

  def role_has_any_permission?(role_id) do
    count_role_permissions(role_id) > 0
  end

  ## Count
  def count_role_permissions(role_id) do
    RolePermission
    |> where([rp], rp.role_id == ^role_id)
    |> Repo.aggregate(:count)
  end

  def count_permission_roles(permission_id) do
    RolePermission
    |> where([rp], rp.permission_id == ^permission_id)
    |> Repo.aggregate(:count)
  end

  ## List
  def list_role_permissions(role_id) do
    RolePermission
    |> where([rp], rp.role_id == ^role_id)
    |> Repo.all()
  end

  def list_permission_roles(permission_id) do
    RolePermission
    |> where([rp], rp.permission_id == ^permission_id)
    |> Repo.all()
  end

  ## ----------- Validation Helper -----------
  ## Validation

  ## Availability
  def role_permission_available?(role_id, permission_id) do
    not Repo.exists?(
      from rp in RolePermission,
        where: rp.role_id == ^role_id and rp.permission_id == ^permission_id
    )
  end

  ## Integrity checking

  ## ----------- Business Helper -------------
  ## Business Helper
  def permission_in_use?(permission_id) do
    count_permission_roles(permission_id) > 0
  end

  ## Ecto.Multi
  ## Multi Agregate

  ## Domain Operation
  def assign_permission(role_id, permission_id) do
    %RolePermission{}
    |> RolePermission.changeset(%{role_id: role_id, permission_id: permission_id})
    |> Repo.insert()
  end

  def revoke_permission(role_id, permission_id) do
    case get_role_permission(role_id, permission_id) do
      nil -> {:error, :not_found}
      %RolePermission{} = role_permission -> Repo.delete(role_permission)
    end
  end
end
