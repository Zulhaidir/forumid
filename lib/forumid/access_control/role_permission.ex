defmodule Forumid.AccessControl.RolePermission do
  use Forumid.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Forumid.Accounts.User
  alias Forumid.Authorization.Role
  alias Forumid.Authorization.Permission

  @type t :: %__MODULE__{}
  schema "role_permissions" do
    belongs_to :role, Role
    belongs_to :permission, Permission

    # Audit trail
    field :granted_by, :binary_id
    field :is_active, :boolean, default: true
    field :granted_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(role_permission, attrs) do
    role_permission
    |> cast(attrs, [:role_id, :permission_id, :granted_by, :granted_at, :is_active])
    |> validate_required([:role_id, :permission_id])
    |> validate_role_exists()
    |> validate_permission_exists()
    |> validate_granted_by_exists()
    |> unique_constraint(:role_permission, name: :role_permissions_role_id_permission_id_index)
  end

  ## Pengganti foreign_key_constraint(:role_id)
  ## prepare_changes mencegah masalah race condition (di mana data induk tiba-tiba dihapus oleh pengguna lain tepat sebelum data anak disimpan).
  defp validate_role_exists(changeset) do
    changeset
    |> prepare_changes(fn changeset ->
      role_id = get_field(changeset, :role_id)

      role_exists? =
        Role
        |> where([r], r.id == ^role_id)
        |> lock("FOR UPDATE")
        |> changeset.repo.exists?()

      case role_exists? do
        true -> changeset
        false -> add_error(changeset, :role_id, "role tidak ditemukan")
      end
    end)
  end

  ## Pengganti foreign_key_constraint(:permission_id)
  ## prepare_changes mencegah masalah race condition (di mana data induk tiba-tiba dihapus oleh pengguna lain tepat sebelum data anak disimpan).
  defp validate_permission_exists(changeset) do
    changeset
    |> prepare_changes(fn changeset ->
      permission_id = get_field(changeset, :permission_id)

      permission_exists? =
        Permission
        |> where([p], p.id == ^permission_id)
        |> lock("FOR UPDATE")
        |> changeset.repo.exists?()

      case permission_exists? do
        true -> changeset
        false -> add_error(changeset, :permission_id, "permission tidak ditemukan")
      end
    end)
  end

  ## Pengganti foreign_key_constraint(:granted_by)
  ## prepare_changes mencegah masalah race condition (di mana data induk tiba-tiba dihapus oleh pengguna lain tepat sebelum data anak disimpan).
  defp validate_granted_by_exists(changeset) do
    changeset
    |> prepare_changes(fn changeset ->
      case get_field(changeset, :granted_by) do
        nil ->
          changeset

        granted_by ->
          granted_by_exists? =
            User
            |> where([u], u.id == ^granted_by)
            |> lock("FOR UPDATE")
            |> changeset.repo.exists?()

          case granted_by_exists? do
            true ->
              changeset

            false ->
              add_error(changeset, :granted_by, "user yang memberikan permission tidak ditemukan")
          end
      end
    end)
  end
end
