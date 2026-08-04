defmodule Forumid.Authorization do
  import Ecto.Query, warn: false

  alias Forumid.Repo
  alias Forumid.Accounts.User
  alias Forumid.Authorization.Role
  alias Forumid.Authorization.Permission
  alias Forumid.AccessControl.UserRole
  alias Forumid.AccessControl.RolePermission

  ## =========================================
  ## Role CRUD
  ## =========================================

  @doc "Membuat role baru"
  @spec create_role(map()) :: {:ok, Role.t()} | {:error, Ecto.Changeset.t()}
  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  @doc "Mengambil semua role"
  @spec list_roles() :: [Role.t()]
  def list_roles, do: Repo.all(Role)

  @doc "Mengambil role berdasarkan ID, jika tidak ditemukan akan melempar error"
  @spec get_role!(Ecto.UUID.t()) :: Role.t()
  def get_role!(id), do: Repo.get!(Role, id)

  @doc "Memperbarui role"
  @spec update_role(Role.t(), map()) :: {:ok, Role.t()} | {:error, Ecto.Changeset.t()}
  def update_role(%Role{} = role, attrs) do
    role
    |> Role.changeset(attrs)
    |> Repo.update(
      stale_error_field: :lock_version,
      stale_error_message: "role ini sudah diubah di tempat lain, silakan muat ulang data terbaru"
    )
  end

  @doc "Menghapus role"
  @spec delete_role(Role.t()) :: {:ok, Role.t()} | {:error, Ecto.Changeset.t()}
  def delete_role(%Role{} = role) do
    Repo.delete(role)
  end

  @doc "Membuat perubahan pada role tanpa menyimpannya ke database"
  @spec change_role(Role.t(), map()) :: Ecto.Changeset.t()
  def change_role(%Role{} = role, attrs \\ %{}) do
    Role.changeset(role, attrs)
  end

  ## =========================================
  ## Permission CRUD
  ## =========================================

  @doc "Membuat permission baru"
  @spec create_permission(map()) :: {:ok, Permission.t()} | {:error, Ecto.Changeset.t()}
  def create_permission(attrs \\ %{}) do
    %Permission{}
    |> Permission.changeset(attrs)
    |> Repo.insert()
  end

  @doc "Mengambil semua permission"
  @spec list_permissions() :: [Permission.t()]
  def list_permissions, do: Repo.all(Permission)

  @doc "Mengambil permission berdasarkan ID, jika tidak ditemukan akan melempar error"
  @spec get_permission!(Ecto.UUID.t()) :: Permission.t()
  def get_permission!(id), do: Repo.get!(Permission, id)

  @doc "Memperbarui permission"
  @spec update_permission(Permission.t(), map()) ::
          {:ok, Permission.t()} | {:error, Ecto.Changeset.t()}
  def update_permission(%Permission{} = permission, attrs) do
    permission
    |> Permission.changeset(attrs)
    |> Repo.update(
      stale_error_field: :lock_version,
      stale_error_message:
        "permission ini sudah diubah di tempat lain, silakan muat ulang data terbaru"
    )
  end

  @doc "Menghapus permission"
  @spec delete_permission(Permission.t()) :: {:ok, Permission.t()} | {:error, Ecto.Changeset.t()}
  def delete_permission(%Permission{} = permission) do
    Repo.delete(permission)
  end

  @doc "Membuat perubahan pada permission tanpa menyimpannya ke database"
  @spec change_permission(Permission.t(), map()) :: Ecto.Changeset.t()
  def change_permission(%Permission{} = permission, attrs \\ %{}) do
    Permission.changeset(permission, attrs)
  end

  ## =========================================
  ## QUERY Role
  ## =========================================

  @doc "Melihat role apa saja yang dimiliki oleh seorang user"
  @spec roles_for_user(User.t()) :: [Role.t()]
  def roles_for_user(%User{} = user) do
    UserRole
    |> where([ur], ur.user_id == ^user.id and ur.is_active == true)
    |> join(:inner, [ur], r in Role, on: ur.role_id == r.id)
    |> select([_ur, r], r)
    |> Repo.all()
  end

  ## =========================================
  ## QUERY Permission
  ## =========================================

  @doc "Melihat permission apa saja yang dimiliki oleh sebuah role"
  @spec permissions_for_role(Role.t()) :: [Permission.t()]
  def permissions_for_role(%Role{} = role) do
    RolePermission
    |> where([rp], rp.role_id == ^role.id)
    |> join(:inner, [rp], p in Permission, on: rp.permission_id == p.id)
    |> select([_rp, p], p)
    |> Repo.all()
  end

  @doc "Melihat permission apa saja yang dimiliki oleh seorang user"
  @spec permissions_for_user(User.t()) :: [Permission.t()]
  def permissions_for_user(%User{} = user) do
    UserRole
    |> where([ur], ur.user_id == ^user.id and ur.is_active == true)
    |> join(:inner, [ur], rp in RolePermission, on: ur.role_id == rp.role_id)
    |> join(:inner, [_ur, rp], p in Permission, on: rp.permission_id == p.id)
    |> select([_ur, _rp, p], p)
    |> distinct(true)
    |> Repo.all()
  end

  ## =========================================
  ## Authorization Checks
  ## =========================================

  @doc "Memeriksa apakah user memiliki role tertentu"
  @spec has_role?(User.t(), binary()) :: boolean()
  def has_role?(%User{} = user, role_name) when is_binary(role_name) do
    UserRole
    |> where([ur], ur.user_id == ^user.id and ur.is_active == true)
    |> join(:inner, [ur], r in Role, on: ur.role_id == r.id)
    |> where([_ur, r], r.name == ^role_name)
    |> Repo.exists?()
  end

  @doc "Memeriksa apakah user memiliki permission tertentu"
  @spec has_permission?(User.t(), binary(), binary()) :: boolean()
  def has_permission?(%User{} = user, resource, action)
      when is_binary(resource) and is_binary(action) do
    UserRole
    |> where([ur], ur.user_id == ^user.id and ur.is_active == true)
    |> join(:inner, [ur], rp in RolePermission, on: ur.role_id == rp.role_id)
    |> join(:inner, [_ur, rp], p in Permission, on: rp.permission_id == p.id)
    |> where([_ur, _rp, p], p.resource == ^resource)
    |> where([_ur, _rp, p], p.action == ^action)
    |> Repo.exists?()
  end

  @doc "Memeriksa apakah user dapat melakukan aksi tertentu pada sumber daya tertentu"
  @spec can?(User.t(), binary(), binary()) :: boolean()
  def can?(%User{} = user, resource, action) when is_binary(resource) and is_binary(action) do
    has_permission?(user, resource, action)
  end

  ## =========================================
  ## Scope Helpers
  ## =========================================

  @doc """
  Mengambil daftar permission untuk user dalam format string "resource:action".
  Berguna untuk dimasukkan ke dalam Scope agar pengecekan di memori menjadi O(1).
  """
  @spec permission_strings_for_user(User.t()) :: [String.t()]
  def permission_strings_for_user(%User{} = user) do
    permissions_for_user(user)
    |> Enum.map(fn p -> "#{p.resource}:#{p.action}" end)
  end
end
