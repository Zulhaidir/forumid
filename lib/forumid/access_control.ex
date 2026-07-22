defmodule Forumid.AccessControl do
  @moduledoc """
  The AccessControl context.
  """

  import Ecto.Query, warn: false
  alias Forumid.Repo

  alias Forumid.AccessControl.UserRole
  alias Forumid.AccessControl.RolePermission

  ## =========================================
  ## UserRole CRUD
  ## =========================================

  @doc "Membuat user_role baru"
  @spec create_user_role(map()) :: {:ok, UserRole.t()} | {:error, Ecto.Changeset.t()}
  def create_user_role(attrs \\ %{}) do
    %UserRole{}
    |> UserRole.changeset(attrs)
    |> Repo.insert()
  end

  @doc "Mengambil semua user_role"
  @spec list_user_roles() :: [UserRole.t()]
  def list_user_roles, do: Repo.all(UserRole)

  @doc "Mengambil user_role berdasarkan ID, jika tidak ditemukan akan melempar error"
  @spec get_user_role!(Ecto.UUID.t()) :: UserRole.t()
  def get_user_role!(id), do: Repo.get!(UserRole, id)

  @doc "Memperbarui user_role"
  @spec update_user_role(UserRole.t(), map()) ::
          {:ok, UserRole.t()} | {:error, Ecto.Changeset.t()}
  def update_user_role(%UserRole{} = user_role, attrs) do
    user_role
    |> UserRole.changeset(attrs)
    |> Repo.update()
  end

  @doc "Menghapus user_role"
  @spec delete_user_role(UserRole.t()) :: {:ok, UserRole.t()} | {:error, Ecto.Changeset.t()}
  def delete_user_role(%UserRole{} = user_role) do
    Repo.delete(user_role)
  end

  @doc "Membuat perubahan pada user_role tanpa menyimpannya ke database"
  @spec change_user_role(UserRole.t(), map()) :: Ecto.Changeset.t()
  def change_user_role(%UserRole{} = user_role, attrs \\ %{}) do
    UserRole.changeset(user_role, attrs)
  end

  ## =========================================
  ## RolePermission CRUD
  ## =========================================

  @doc "Membuat role_permission baru"
  @spec create_role_permission(map()) :: {:ok, RolePermission.t()} | {:error, Ecto.Changeset.t()}
  def create_role_permission(attrs \\ %{}) do
    %RolePermission{}
    |> RolePermission.changeset(attrs)
    |> Repo.insert()
  end

  @doc "Mengambil semua role_permission"
  @spec list_role_permissions() :: [RolePermission.t()]
  def list_role_permissions do
    Repo.all(RolePermission)
  end

  @doc "Mengambil role_permission berdasarkan ID, jika tidak ditemukan akan melempar error"
  @spec get_role_permission!(Ecto.UUID.t()) :: RolePermission.t()
  def get_role_permission!(id), do: Repo.get!(RolePermission, id)

  @doc "Memperbarui role_permission"
  @spec update_role_permission(RolePermission.t(), map()) ::
          {:ok, RolePermission.t()} | {:error, Ecto.Changeset.t()}
  def update_role_permission(%RolePermission{} = role_permission, attrs) do
    role_permission
    |> RolePermission.changeset(attrs)
    |> Repo.update()
  end

  @doc "Menghapus role_permission"
  @spec delete_role_permission(RolePermission.t()) ::
          {:ok, RolePermission.t()} | {:error, Ecto.Changeset.t()}
  def delete_role_permission(%RolePermission{} = role_permission) do
    Repo.delete(role_permission)
  end

  @doc "Membuat perubahan pada role_permission tanpa menyimpannya ke database"
  @spec change_role_permission(RolePermission.t(), map()) :: Ecto.Changeset.t()
  def change_role_permission(%RolePermission{} = role_permission, attrs \\ %{}) do
    RolePermission.changeset(role_permission, attrs)
  end

  ## =========================================
  ## Role Assignments
  ## =========================================

  defp find_user_role(user_id, role_id)
       when is_binary(user_id) and is_binary(role_id) do
    Repo.get_by(UserRole, user_id: user_id, role_id: role_id)
  end

  @doc "Memberikan role pada user"
  @spec assign_role(String.t(), String.t()) ::
          {:ok, UserRole.t()} | {:error, :role_already_assigned | Ecto.Changeset.t()}
  def assign_role(user_id, role_id)
      when is_binary(user_id) and is_binary(role_id) do
    case find_user_role(user_id, role_id) do
      nil ->
        %UserRole{}
        |> UserRole.changeset(%{
          user_id: user_id,
          role_id: role_id,
          is_active: true
        })
        |> Repo.insert()

      %UserRole{is_active: true} ->
        {:error, :role_already_assigned}

      %UserRole{is_active: false} = user_role ->
        user_role
        |> UserRole.changeset(%{is_active: true})
        |> Repo.update()
    end
  end

  @doc "Mencabut role yang ada pada user"
  @spec revoke_role(String.t(), String.t()) ::
          {:ok, UserRole.t()} | {:error, :not_found | :role_already_revoked}
  def revoke_role(user_id, role_id)
      when is_binary(user_id) and is_binary(role_id) do
    case find_user_role(user_id, role_id) do
      nil ->
        {:error, :not_found}

      %UserRole{is_active: true} = user_role ->
        user_role
        |> UserRole.changeset(%{is_active: false})
        |> Repo.update()

      %UserRole{is_active: false} ->
        {:error, :role_already_revoked}
    end
  end

  ## =========================================
  ## Permission Assignments
  ## =========================================

  defp find_role_permission(role_id, permission_id)
       when is_binary(role_id) and is_binary(permission_id) do
    Repo.get_by(RolePermission, role_id: role_id, permission_id: permission_id)
  end

  @doc "Memberikan permission pada role"
  @spec assign_permission(String.t(), String.t()) ::
          {:ok, RolePermission.t()} | {:error, :permission_already_assigned | Ecto.Changeset.t()}
  def assign_permission(role_id, permission_id)
      when is_binary(role_id) and is_binary(permission_id) do
    case find_role_permission(role_id, permission_id) do
      nil ->
        %RolePermission{}
        |> RolePermission.changeset(%{
          role_id: role_id,
          permission_id: permission_id,
          is_active: true
        })
        |> Repo.insert()

      %RolePermission{is_active: true} ->
        {:error, :permission_already_assigned}

      %RolePermission{is_active: false} = role_permission ->
        role_permission
        |> RolePermission.changeset(%{is_active: true})
        |> Repo.update()
    end
  end

  @doc "Mencabut permission pada role"
  @spec revoke_permission(String.t(), String.t()) ::
          {:ok, RolePermission.t()} | {:error, :not_found | :permission_already_revoked}
  def revoke_permission(role_id, permission_id)
      when is_binary(role_id) and is_binary(permission_id) do
    case find_role_permission(role_id, permission_id) do
      nil ->
        {:error, :not_found}

      %RolePermission{is_active: true} = role_permission ->
        role_permission
        |> RolePermission.changeset(%{is_active: false})
        |> Repo.update()

      %RolePermission{is_active: false} ->
        {:error, :permission_already_revoked}
    end
  end
end
