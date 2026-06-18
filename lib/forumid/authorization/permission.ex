defmodule Forumid.Authorization.Permission do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "permissions" do
    field :resource, :string
    field :action, :string
    field :description, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(permission, attrs) do
    permission
    |> cast(attrs, [:resource, :action, :description])
    |> validate_required([:resource, :action])
    |> validate_length(:resource, min: 2, max: 100)
    |> validate_length(:action, min: 2, max: 100)
    |> unique_constraint([:resource, :action])
  end
end
