defmodule Forumid.AuditTest do
  use Forumid.DataCase

  import Forumid.AccountsFixtures
  import Forumid.AuditFixtures

  alias Forumid.Audit
  alias Forumid.Audit.ActivityLog

  describe "activity_logs" do
    @invalid_attrs %{description: nil, resource: nil, action: nil, resource_id: nil}

    test "list_activity_logs/0 returns all activity_logs" do
      activity_log = activity_log_fixture()
      assert Audit.list_activity_logs() == [activity_log]
    end

    test "get_activity_log!/1 returns the activity_log with given id" do
      activity_log = activity_log_fixture()
      assert Audit.get_activity_log!(activity_log.id) == activity_log
    end

    test "create_activity_log/1 with valid data creates a activity_log" do
      user = user_fixture()

      valid_attrs = %{
        description: "some description",
        resource: "some resource",
        action: "some action",
        resource_id: Ecto.UUID.generate(),
        user_id: user.id
      }

      assert {:ok, %ActivityLog{} = activity_log} = Audit.create_activity_log(valid_attrs)
      assert activity_log.description == "some description"
      assert activity_log.resource == "some resource"
      assert activity_log.action == "some action"
    end

    test "create_activity_log/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Audit.create_activity_log(@invalid_attrs)
    end

    test "update_activity_log/2 with valid data updates the activity_log" do
      activity_log = activity_log_fixture()

      update_attrs = %{
        description: "some updated description",
        resource: "some updated resource",
        action: "some updated action"
      }

      assert {:ok, %ActivityLog{} = activity_log} =
               Audit.update_activity_log(activity_log, update_attrs)

      assert activity_log.description == "some updated description"
      assert activity_log.resource == "some updated resource"
      assert activity_log.action == "some updated action"
    end

    test "update_activity_log/2 with invalid data returns error changeset" do
      activity_log = activity_log_fixture()
      assert {:error, %Ecto.Changeset{}} = Audit.update_activity_log(activity_log, @invalid_attrs)
      assert activity_log == Audit.get_activity_log!(activity_log.id)
    end

    test "delete_activity_log/1 deletes the activity_log" do
      activity_log = activity_log_fixture()
      assert {:ok, %ActivityLog{}} = Audit.delete_activity_log(activity_log)
      assert_raise Ecto.NoResultsError, fn -> Audit.get_activity_log!(activity_log.id) end
    end

    test "change_activity_log/1 returns a activity_log changeset" do
      activity_log = activity_log_fixture()
      assert %Ecto.Changeset{} = Audit.change_activity_log(activity_log)
    end
  end
end
