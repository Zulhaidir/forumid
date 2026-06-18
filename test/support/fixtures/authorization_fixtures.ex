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
end
