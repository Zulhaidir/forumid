defmodule Forumid.AccessControlFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Forumid.AccessControl` context.
  """

  alias Forumid.AccessControl

  import Forumid.AccountsFixtures
  import Forumid.AuthorizationFixtures

  @doc """
  Generate a user_role.
  """
  def user_role_fixture(attrs \\ %{}) do
    user = user_fixture()
    role = role_fixture()

    {:ok, user_role} =
      attrs
      |> Enum.into(%{
        user_id: user.id,
        role_id: role.id,
        assigned_at: DateTime.utc_now(:second),
        is_active: true,
        assigned_by: nil
      })
      |> AccessControl.create_user_role()

    user_role
  end

  @doc """
  Generate a role_permission.
  """
  def role_permission_fixture(attrs \\ %{}) do
    role = role_fixture()
    permission = permission_fixture()
    admin = user_fixture()

    {:ok, role_permission} =
      attrs
      |> Enum.into(%{
        role_id: role.id,
        permission_id: permission.id,
        granted_by: admin.id,
        granted_at: DateTime.utc_now(:second)
      })
      |> AccessControl.create_role_permission()

    role_permission
  end
end
