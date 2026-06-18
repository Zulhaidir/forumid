defmodule Forumid.Authorization do
  import Ecto.Query, warn: false
  alias Forumid.Repo

  alias Forumid.Authorization.Role

  ## LIST
  def list_roles do
    Repo.all(Role)
  end

  ## GET
  def get_role!(id), do: Repo.get!(Role, id)

  ## CREATE
  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  ## UPDATE
  def update_role(%Role{} = role, attrs) do
    role
    |> Role.changeset(attrs)
    |> Repo.update()
  end

  ## DELETE
  def delete_role(%Role{} = role) do
    Repo.delete(role)
  end

  ## CHANGE
  def change_role(%Role{} = role, attrs \\ %{}) do
    Role.changeset(role, attrs)
  end
end
