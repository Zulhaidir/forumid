# defmodule Forumid.AccessControlFixtures do
#   @moduledoc """
#   This module defines test helpers for creating
#   entities via the `Forumid.AccessControl` context.
#   """

#   @doc """
#   Generate a user_role.
#   """
#   def user_role_fixture(attrs \\ %{}) do
#     user = user_fixture()

#     {:ok, user_role} =
#       attrs
#       |> Enum.into(%{

#       })
#       |> Forumid.AccessControl.create_user_role()

#     user_role
#   end
# end

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
end
