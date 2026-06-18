defmodule Forumid.AuthorizationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Forumid.Authorization` context.
  """

  @doc """
  Generate a role.
  """
  def role_fixture(attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        name: "editor",
        description: "Editor role"
      })

    {:ok, role} = Forumid.Authorization.create_role(attrs)
    role
  end

  @doc """
  Generate a permission.
  """
  def permission_fixture(attrs \\ %{}) do
    {:ok, permission} =
      attrs
      |> Enum.into(%{
        resource: "article",
        action: "create",
        description: "Can create article"
      })
      |> Forumid.Authorization.create_permission()

    permission
  end
end
