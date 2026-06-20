defmodule Forumid.Profiles.UserProfile do
  use Ecto.Schema
  import Ecto.Changeset

  alias Forumid.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "user_profiles" do
    field :full_name, :string
    field :username, :string
    field :avatar_url, :string
    field :bio, :string
    field :phone, :string
    field :is_active, :boolean, default: false

    belongs_to :user, User, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_profile, attrs) do
    user_profile
    |> cast(attrs, [:full_name, :username, :avatar_url, :bio, :phone, :is_active])
    |> validate_required([:full_name, :username])
    |> unique_constraint(:username)
  end

  def registration_changeset(user_profile, attrs) do
    user_profile
    |> cast(attrs, [:user_id, :username, :is_active])
    |> validate_required([:user_id, :username])
    |> unique_constraint(:user_id)
    |> unique_constraint(:username)
    |> foreign_key_constraint(:user_id)
  end
end
