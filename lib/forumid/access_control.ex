defmodule Forumid.AccessControl do
  @moduledoc """
  The AccessControl context.
  """

  import Ecto.Query, warn: false
  alias Forumid.Repo

  alias Forumid.AccessControl.UserRole

  ## LIST
  def list_user_roles do
    Repo.all(UserRole)
  end

  ## GET
  def get_user_role!(id), do: Repo.get!(UserRole, id)

  ## CREATE
  def create_user_role(attrs) do
    %UserRole{}
    |> UserRole.changeset(attrs)
    |> Repo.insert()
  end

  ## UPDATE
  def update_user_role(%UserRole{} = user_role, attrs) do
    user_role
    |> UserRole.changeset(attrs)
    |> Repo.update()
  end

  ## DELETE
  def delete_user_role(%UserRole{} = user_role) do
    Repo.delete(user_role)
  end

  ## CHANGE
  def change_user_role(%UserRole{} = user_role, attrs \\ %{}) do
    UserRole.changeset(user_role, attrs)
  end
end
