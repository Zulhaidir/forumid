defmodule Forumid.Audit.ActivityLog do
  use Forumid.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Forumid.Accounts.User

  schema "activity_logs" do
    field :action, :string
    field :resource, :string
    field :resource_id, :binary_id
    field :description, :string
    field :lock_version, :integer, default: 1
    belongs_to :user, User
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(activity_log, attrs) do
    activity_log
    |> cast(attrs, [:action, :resource, :resource_id, :description, :user_id])
    |> validate_required([:action, :resource, :resource_id, :description, :user_id])
    |> validate_user_exists()
    |> optimistic_lock(:lock_version)
  end

  # Pengganti foreign_key_constraint(:user_id)
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
