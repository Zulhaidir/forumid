defmodule Forumid.AccessControl.RolePermission do
  use Ecto.Schema
  import Ecto.Changeset

  alias Forumid.Repo
  alias Forumid.Accounts.User
  alias Forumid.Authorization.Role
  alias Forumid.Authorization.Permission

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "role_permissions" do
    belongs_to :role, Role
    belongs_to :permission, Permission

    # Audit trail
    field :granted_by, :binary_id
    field :granted_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(role_permission, attrs) do
    role_permission
    |> cast(attrs, [:role_id, :permission_id, :granted_by, :granted_at])
    |> validate_required([:role_id, :permission_id])
    |> validate_role_exists()
    |> validate_permission_exists()
    |> validate_granted_by_exists()
    |> unique_constraint([:role_id, :permission_id])
  end

  # Pengganti foreign_key_constraint(:role_id)
  defp validate_role_exists(changeset) do
    role_id = get_field(changeset, :role_id)

    if role_id do
      case Repo.get(Role, role_id) do
        nil -> add_error(changeset, :role_id, "role tidak ditemukan")
        _ -> changeset
      end
    else
      changeset
    end
  end

  # Pengganti foreign_key_constraint(:permission_id)
  defp validate_permission_exists(changeset) do
    permission_id = get_field(changeset, :permission_id)

    if permission_id do
      case Repo.get(Permission, permission_id) do
        nil -> add_error(changeset, :permission_id, "permission tidak ditemukan")
        _ -> changeset
      end
    else
      changeset
    end
  end

  # Pengganti foreign_key_constraint(:granted_by)
  defp validate_granted_by_exists(changeset) do
    granted_by = get_field(changeset, :granted_by)

    if granted_by do
      case Repo.get(User, granted_by) do
        nil -> add_error(changeset, :granted_by, "granted_by tidak ditemukan")
        _ -> changeset
      end
    else
      changeset
    end
  end
end
