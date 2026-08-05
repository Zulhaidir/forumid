defmodule Forumid.Forum.Tag do
  use Forumid.Schema
  import Ecto.Changeset

  schema "tags" do
    field :name, :string
    field :slug, :string
    field :lock_version, :integer, default: 1
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name, :slug])
    |> validate_required([:name, :slug])
    |> unique_constraint(:slug)
    |> optimistic_lock(:lock_version)
  end
end
