defmodule Forumid.AuditFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Forumid.Audit` context.
  """
  import Forumid.AccountsFixtures

  @doc """
  Generate a activity_log.
  """
  def activity_log_fixture(attrs \\ %{}) do
    user = user_fixture()

    attrs =
      Enum.into(attrs, %{
        action: "some action",
        description: "some description",
        lock_version: 42,
        resource: "some resource",
        resource_id: Ecto.UUID.generate(),
        user_id: user.id
      })

    {:ok, activity_log} = Forumid.Audit.create_activity_log(attrs)

    activity_log
  end
end
