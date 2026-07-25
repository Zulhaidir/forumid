defmodule Forumid.Authorization.Role do
  use Forumid.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}
  schema "roles" do
    field :name, :string
    field :description, :string
    field :lock_version, :integer, default: 1
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
    |> validate_length(:name, min: 2, max: 100)
    |> unique_constraint(:name, name: :roles_name_index)
    |> optimistic_lock(:lock_version)
  end
end
