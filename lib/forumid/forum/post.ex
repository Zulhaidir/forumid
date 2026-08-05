defmodule Forumid.Forum.Post do
  use Forumid.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Forumid.Forum.Topic
  alias Forumid.Accounts.User

  schema "posts" do
    field :body, :string
    field :lock_version, :integer, default: 1
    belongs_to :topic, Topic
    belongs_to :user, User
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body, :user_id, :topic_id])
    |> validate_required([:body, :user_id, :topic_id])
    |> validate_length(:body, min: 1)
    |> validate_topic_exists()
    |> validate_user_exists()
    |> optimistic_lock(:lock_version)
  end

  # foreign_key_constraint(:topic_id)
  defp validate_topic_exists(changeset) do
    changeset
    |> prepare_changes(fn changeset ->
      topic_id = get_field(changeset, :topic_id)

      topic_exists? =
        Topic
        |> where([u], u.id == ^topic_id)
        |> lock("FOR UPDATE")
        |> changeset.repo.exists?()

      case topic_exists? do
        true -> changeset
        false -> add_error(changeset, :topic_id, "topic tidak ditemukan")
      end
    end)
  end

  # foreign_key_constraint(:user_id)
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
