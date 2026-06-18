defmodule Forumid.Authorization do
  import Ecto.Query, warn: false
  alias Forumid.Repo

  alias Forumid.Authorization.Role
  alias Forumid.Authorization.Permission

  ## -----------------------------------------
  ## Role
  ## -----------------------------------------

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

  ## -----------------------------------------
  ## Permissison
  ## -----------------------------------------

  ## LIST
  def list_permissions do
    Repo.all(Permission)
  end

  ## GET
  def get_permission!(id), do: Repo.get!(Permission, id)

  ## CREATE
  def create_permission(attrs \\ %{}) do
    %Permission{}
    |> Permission.changeset(attrs)
    |> Repo.insert()
  end

  ## UPDATE
  def update_permission(%Permission{} = permission, attrs) do
    permission
    |> Permission.changeset(attrs)
    |> Repo.update()
  end

  ## DELETE
  def delete_permission(%Permission{} = permission) do
    Repo.delete(permission)
  end

  ## CHANGE
  def change_permission(%Permission{} = permission, attrs \\ %{}) do
    Permission.changeset(permission, attrs)
  end
end
