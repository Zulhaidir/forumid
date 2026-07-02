defmodule Forumid.Authorization do
  import Ecto.Query, warn: false

  alias Forumid.Repo
  alias Forumid.Authorization.Role
  alias Forumid.Authorization.Permission
  alias Forumid.AccessControl.UserRole
  alias Forumid.AccessControl.RolePermission

  ## =========================================
  ## Role
  ## =========================================

  ## ----------------- CRUD ------------------

  def list_roles, do: Repo.all(Role)

  def get_role!(id), do: Repo.get!(Role, id)

  @doc """
  Membuat role baru.
  Validasi uniqueness ditangani oleh changeset via unique_constraint.
  """
  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Mengupdate role.
  Role sistem tidak boleh diubah namanya karena nama adalah identitasnya.
  Field lain seperti description tetap boleh diubah.
  """
  def update_role(%Role{} = role, attrs) do
    if system_role?(role) and has_name_change?(attrs) do
      {:error, {:role, :cannot_rename_system_role}}
    else
      role
      |> Role.changeset(attrs)
      |> Repo.update()
    end
  end

  @doc """
  Menghapus role.
  Mendelegasikan seluruh pengecekan ke can_delete_role?/1
  untuk menghindari duplikasi logika bisnis.
  """
  def delete_role(%Role{} = role) do
    if can_delete_role?(role) do
      Repo.delete(role)
    else
      {:error, deletion_error_reason(role)}
    end
  end

  def change_role(%Role{} = role, attrs \\ %{}) do
    Role.changeset(role, attrs)
  end

  ## --------------- Helper ------------------

  @doc "Mengambil role berdasarkan nama."
  def get_role_by_name(name) when is_binary(name) do
    Repo.get_by(Role, name: name)
  end

  @doc "Mengembalikan daftar nama seluruh role."
  def list_role_names do
    Role
    |> select([r], r.name)
    |> Repo.all()
  end

  @doc "Mengecek apakah role dengan id tertentu ada."
  def role_exists?(id) do
    Role
    |> where([r], r.id == ^id)
    |> Repo.exists?()
  end

  @doc "Mengecek apakah nama role sudah terdaftar di database."
  def role_name_exists?(name) when is_binary(name) do
    Role
    |> where([r], r.name == ^name)
    |> Repo.exists?()
  end

  @doc """
  Mengembalikan daftar user aktif yang memiliki role ini.
  Berguna untuk Admin Panel yang menampilkan siapa saja pemegang role.
  """
  def list_role_users(%Role{id: id}) do
    UserRole
    |> where([ur], ur.role_id == ^id and ur.is_active == true)
    |> Repo.all()
  end

  @doc """
  Mengembalikan jumlah user aktif yang memiliki role ini.
  Menggunakan Repo.aggregate agar tidak memuat seluruh row ke memori.
  """
  def count_role_users(%Role{id: id}) do
    UserRole
    |> where([ur], ur.role_id == ^id and ur.is_active == true)
    |> Repo.aggregate(:count)
  end

  @doc "Mengembalikan jumlah permission yang terpasang pada role ini."
  def count_role_permissions(%Role{id: id}) do
    RolePermission
    |> where([rp], rp.role_id == ^id)
    |> Repo.aggregate(:count)
  end

  ## ----------- Validation Helper -----------

  @doc "Memvalidasi bahwa role dengan id tertentu ada di database."
  def valid_role?(id), do: role_exists?(id)

  @doc """
  Memvalidasi bahwa nama role tersedia untuk digunakan.
  Mengembalikan true jika nama BELUM ada di database.
  """
  def valid_role_name?(name) when is_binary(name) do
    not role_name_exists?(name)
  end

  ## ----------- Business Helper -------------

  defp system_roles do
    Application.fetch_env!(:forumid, :system_roles)
  end

  @doc """
  Mengecek apakah role merupakan role bawaan sistem.
  Role sistem dikonfigurasi via `config :forumid, system_roles`.

  ## Contoh

      iex> system_role?(%Role{name: "admin"})
      true

      iex> system_role?(%Role{name: "editor"})
      false

  """
  def system_role?(%Role{name: name}) do
    String.downcase(name) in Enum.map(system_roles(), &String.downcase/1)
  end

  @doc """
  Mengecek apakah role sedang digunakan oleh minimal satu user aktif.
  Dibangun di atas count_role_users/1 agar tidak menduplikasi query.
  """
  def role_in_use?(%Role{} = role) do
    count_role_users(role) > 0
  end

  @doc """
  Mengecek apakah role masih memiliki permission yang terpasang.
  Dibangun di atas count_role_permissions/1 agar tidak menduplikasi query.
  """
  def role_has_permissions?(%Role{} = role) do
    count_role_permissions(role) > 0
  end

  @doc """
  Mengecek apakah role boleh dihapus.

  Sebuah role boleh dihapus hanya jika memenuhi ketiga syarat:
  1. Bukan role sistem.
  2. Tidak sedang digunakan user aktif.
  3. Tidak memiliki permission terpasang.
  """
  def can_delete_role?(%Role{} = role) do
    not system_role?(role) and
      not role_in_use?(role) and
      not role_has_permissions?(role)
  end

  ## =========================================
  ## Permission
  ## =========================================

  ## ----------------- CRUD ------------------

  def list_permissions, do: Repo.all(Permission)

  def get_permission!(id), do: Repo.get!(Permission, id)

  @doc """
  Membuat permission baru.
  Validasi uniqueness ditangani oleh changeset via unique_constraint.
  """
  def create_permission(attrs \\ %{}) do
    %Permission{}
    |> Permission.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Mengupdate permission.
  Permission sistem tidak boleh diubah resource atau action-nya
  karena keduanya adalah identitas permission.
  Field description tetap boleh diubah.
  """
  def update_permission(%Permission{} = permission, attrs) do
    if system_permission?(permission) and has_identity_change?(attrs) do
      {:error, {:permission, :cannot_update_system_permission_identity}}
    else
      permission
      |> Permission.changeset(attrs)
      |> Repo.update()
    end
  end

  @doc """
  Menghapus permission.
  Mendelegasikan seluruh pengecekan ke can_delete_permission?/1
  untuk menghindari duplikasi logika bisnis.
  """
  def delete_permission(%Permission{} = permission) do
    if can_delete_permission?(permission) do
      Repo.delete(permission)
    else
      {:error, permission_deletion_error_reason(permission)}
    end
  end

  def change_permission(%Permission{} = permission, attrs \\ %{}) do
    Permission.changeset(permission, attrs)
  end

  ## --------------- Helper ------------------

  @doc "Mengambil permission berdasarkan resource dan action."
  def get_permission(resource, action)
      when is_binary(resource) and is_binary(action) do
    Repo.get_by(Permission, resource: resource, action: action)
  end

  @doc "Mengecek apakah permission dengan id tertentu ada."
  def permission_exists?(id) when is_binary(id) do
    Permission
    |> where([p], p.id == ^id)
    |> Repo.exists?()
  end

  @doc "Mengecek apakah permission dengan resource dan action tertentu ada."
  def permission_exists?(resource, action)
      when is_binary(resource) and is_binary(action) do
    Permission
    |> where([p], p.resource == ^resource and p.action == ^action)
    |> Repo.exists?()
  end

  @doc "Mengembalikan daftar permission berdasarkan resource, diurutkan berdasarkan action."
  def list_permissions_by_resource(resource) when is_binary(resource) do
    Permission
    |> where([p], p.resource == ^resource)
    |> order_by([p], asc: p.action)
    |> Repo.all()
  end

  @doc "Mengembalikan jumlah role yang menggunakan permission ini."
  def count_permission_roles(%Permission{id: id}) do
    RolePermission
    |> where([rp], rp.permission_id == ^id)
    |> Repo.aggregate(:count)
  end

  ## ----------- Validation Helper -----------

  @doc "Memvalidasi bahwa permission dengan id tertentu ada di database."
  def valid_permission?(id) when is_binary(id), do: permission_exists?(id)

  @doc "Memvalidasi bahwa permission dengan resource dan action tertentu ada."
  def valid_permission?(resource, action)
      when is_binary(resource) and is_binary(action) do
    permission_exists?(resource, action)
  end

  ## ----------- Business Helper -------------

  defp system_permissions do
    Application.fetch_env!(:forumid, :system_permissions)
  end

  @doc """
  Mengecek apakah permission merupakan permission bawaan sistem.
  Permission sistem dikonfigurasi via `config :forumid, system_permissions`.
  """
  def system_permission?(%Permission{resource: resource, action: action}) do
    {String.downcase(resource), String.downcase(action)} in system_permissions()
  end

  @doc """
  Mengecek apakah permission sedang digunakan oleh minimal satu role.
  Dibangun di atas count_permission_roles/1 agar tidak menduplikasi query.
  """
  def permission_in_use?(%Permission{} = permission) do
    count_permission_roles(permission) > 0
  end

  @doc """
  Mengecek apakah permission boleh dihapus.

  Sebuah permission boleh dihapus hanya jika memenuhi kedua syarat:
  1. Bukan permission sistem.
  2. Tidak sedang digunakan role manapun.
  """
  def can_delete_permission?(%Permission{} = permission) do
    not system_permission?(permission) and
      not permission_in_use?(permission)
  end

  ## =========================================
  ## Private Helpers
  ## =========================================

  defp has_name_change?(attrs) do
    Map.has_key?(attrs, :name) or Map.has_key?(attrs, "name")
  end

  defp has_identity_change?(attrs) do
    Map.has_key?(attrs, :resource) or Map.has_key?(attrs, "resource") or
      Map.has_key?(attrs, :action) or Map.has_key?(attrs, "action")
  end

  defp deletion_error_reason(%Role{} = role) do
    cond do
      system_role?(role) -> {:role, :system_role}
      role_in_use?(role) -> {:role, :in_use}
      role_has_permissions?(role) -> {:role, :has_permissions}
    end
  end

  defp permission_deletion_error_reason(%Permission{} = permission) do
    cond do
      system_permission?(permission) -> {:permission, :system_permission}
      permission_in_use?(permission) -> {:permission, :in_use}
    end
  end
end
