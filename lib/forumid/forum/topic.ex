defmodule Forumid.Forum.Topic do
  use Forumid.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Forumid.Forum.Category
  alias Forumid.Accounts.User

  schema "topics" do
    field :title, :string
    field :slug, :string
    field :body, :string
    field :views, :integer, default: 0
    field :is_pinned, :boolean, default: false
    field :is_locked, :boolean, default: false
    field :lock_version, :integer, default: 1
    belongs_to :category, Category
    belongs_to :user, User
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:title, :slug, :body, :views, :is_pinned, :is_locked, :category_id, :user_id])
    |> validate_required([
      :title,
      :slug,
      :body,
      :category_id,
      :user_id
    ])
    |> validate_length(:title, min: 5, max: 255)
    |> validate_length(:body, min: 10)
    |> validate_category_exists()
    |> validate_user_exists()
    |> unique_constraint(:slug)
    |> optimistic_lock(:lock_version)
  end

  # foreign_key_constraint(:category_id)
  defp validate_category_exists(changeset) do
    changeset
    |> prepare_changes(fn changeset ->
      category_id = get_field(changeset, :category_id)

      category_exists? =
        Category
        |> where([c], c.id == ^category_id)
        |> lock("FOR UPDATE")
        |> changeset.repo.exists?()

      case category_exists? do
        true -> changeset
        false -> add_error(changeset, :category_id, "kategory tidak di temukan")
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
        |> where([c], c.id == ^user_id)
        |> lock("FOR UPDATE")
        |> changeset.repo.exists?()

      case user_exists? do
        true -> changeset
        false -> add_error(changeset, :user_id, "user tidak di temukan")
      end
    end)
  end
end
