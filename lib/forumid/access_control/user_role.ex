defmodule Forumid.AccessControl.UserRole do
  use Ecto.Schema
  import Ecto.Changeset

  alias Forumid.Accounts.User
  alias Forumid.Authorization.Role

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "user_roles" do
    field :assigned_at, :utc_datetime
    field :is_active, :boolean, default: true
    field :assigned_by, :binary_id

    belongs_to :user, User
    belongs_to :role, Role

    timestamps(type: :utc_datetime)
  end

  def changeset(user_role, attrs) do
    user_role
    |> cast(attrs, [:user_id, :role_id, :assigned_by, :assigned_at, :is_active])
    |> validate_required([:user_id, :role_id])
    |> validate_user_exists()
    |> validate_role_exists()
    |> validate_assigned_by_exists()
    |> unique_constraint([:user_id, :role_id])
  end

  # Pengganti foreign_key_constraint(:user_id)
  defp validate_user_exists(changeset) do
    user_id = get_field(changeset, :user_id)

    if user_id do
      case Forumid.Repo.get(User, user_id) do
        nil -> add_error(changeset, :user_id, "user tidak di temukan")
        _ -> changeset
      end
    else
      changeset
    end
  end

  # Pengganti foreign_key_constraint(:role_id)
  defp validate_role_exists(changeset) do
    role_id = get_field(changeset, :role_id)

    if role_id do
      case Forumid.Repo.get(Role, role_id) do
        nil -> add_error(changeset, :role_id, "role tidak di temukan")
        _ -> changeset
      end
    else
      changeset
    end
  end

  # Pengganti foreign_key_constraint(:assigned_by)
  defp validate_assigned_by_exists(changeset) do
    assigned_by = get_field(changeset, :assigned_by)

    if assigned_by do
      case Forumid.Repo.get(User, assigned_by) do
        nil -> add_error(changeset, :assigned_by, "assigned_by tidak di temukan")
        _ -> changeset
      end
    else
      changeset
    end
  end
end
