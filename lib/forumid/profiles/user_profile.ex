defmodule Forumid.Profiles.UserProfile do
  use Forumid.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Forumid.Accounts.User

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
    |> validate_user_exists()
    |> unique_constraint(:user_id)
    |> unique_constraint(:username)
  end

  ## Pengganti foreign_key_constraint(:user_id)
  ## prepare_changes mencegah masalah race condition (di mana data induk tiba-tiba dihapus oleh pengguna lain tepat sebelum data anak disimpan).
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
end
