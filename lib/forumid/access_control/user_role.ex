# defmodule Forumid.AccessControl.UserRole do
#   use Ecto.Schema
#   import Ecto.Changeset

#   @primary_key {:id, :binary_id, autogenerate: true}
#   @foreign_key_type :binary_id
#   schema "user_roles" do

#     field :user_id, :binary_id
#     field :role_id, :binary_id

#     timestamps(type: :utc_datetime)
#   end

#   @doc false
#   def changeset(user_role, attrs) do
#     user_role
#     |> cast(attrs, [])
#     |> validate_required([])
#   end
# end

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
    |> unique_constraint([:user_id, :role_id])
  end
end
