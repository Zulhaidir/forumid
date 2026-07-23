defmodule Forumid.AccessControl.UserRole do
  use Forumid.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Forumid.Accounts.User
  alias Forumid.Authorization.Role

  @type t :: %__MODULE__{}
  schema "user_roles" do
    belongs_to :user, User
    belongs_to :role, Role

    # Audit trail
    field :assigned_at, :utc_datetime
    field :is_active, :boolean, default: true
    field :assigned_by, :binary_id

    timestamps(type: :utc_datetime)
  end

  def changeset(user_role, attrs) do
    user_role
    |> cast(attrs, [:user_id, :role_id, :assigned_by, :assigned_at, :is_active])
    |> validate_required([:user_id, :role_id])
    |> validate_user_exists()
    |> validate_role_exists()
    |> validate_assigned_by_exists()
    |> unique_constraint(:user_role, name: :user_roles_user_id_role_id_index)
  end

  ## Pengganti foreign_key_constraint(:user_id)
  ## mencegah masalah race condition (di mana data induk tiba-tiba dihapus oleh pengguna lain tepat sebelum data anak disimpan).
  defp validate_user_exists(changeset) do
    changeset
    |> prepare_changes(fn changeset ->
      user_id = get_field(changeset, :user_id)

      user_exists? =
        User
        |> where([u], u.id == ^user_id)
        |> lock("FOR UPDATE")
        |> changeset.repo.exists?()

      case user_exists? do
        true -> changeset
        false -> add_error(changeset, :user_id, "user tidak ditemukan")
      end
    end)
  end

  ## Pengganti foreign_key_constraint(:role_id)
  ## prepare_changes mencegah masalah race condition (di mana data induk tiba-tiba dihapus oleh pengguna lain tepat sebelum data anak dis
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

  ## Pengganti foreign_key_constraint(:assigned_by)
  ## prepare_changes mencegah masalah race condition (di mana data induk tiba-tiba dihapus oleh pengguna lain tepat sebelum data anak disimpan).
  defp validate_assigned_by_exists(changeset) do
    changeset
    |> prepare_changes(fn changeset ->
      case get_field(changeset, :assigned_by) do
        nil ->
          changeset

        assigned_by ->
          assigned_by_exists? =
            User
            |> where([u], u.id == ^assigned_by)
            |> lock("FOR UPDATE")
            |> changeset.repo.exists?()

          case assigned_by_exists? do
            true -> changeset
            false -> add_error(changeset, :assigned_by, "assigned_by tidak ditemukan")
          end
      end
    end)
  end
end
