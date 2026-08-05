defmodule Forumid.Forum.Category do
  use Forumid.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Forumid.Accounts.User

  schema "categories" do
    field :name, :string
    field :slug, :string
    field :description, :string
    field :lock_version, :integer, default: 1
    belongs_to :user, User
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :slug, :description, :user_id])
    |> validate_required([:name, :slug, :description, :user_id])
    |> validate_user_exists()
    |> unique_constraint(:slug)
    |> optimistic_lock(:lock_version)
  end

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
