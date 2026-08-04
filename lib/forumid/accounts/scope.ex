defmodule Forumid.Accounts.Scope do
  @moduledoc """
  Defines the scope of the caller to be used throughout the app.

  The `Forumid.Accounts.Scope` allows public interfaces to receive
  information about the caller, such as if the call is initiated from an
  end-user, and if so, which user. Additionally, such a scope can carry fields
  such as "super user" or other privileges for use as authorization, or to
  ensure specific code paths can only be access for a given scope.

  It is useful for logging as well as for scoping pubsub subscriptions and
  broadcasts when a caller subscribes to an interface or performs a particular
  action.

  Feel free to extend the fields on this struct to fit the needs of
  growing application requirements.
  """

  alias Forumid.Accounts.User

  defstruct user: nil, permissions: MapSet.new()

  @doc """
  Creates a scope for the given user.

  Returns nil if no user is given.
  """
  def for_user(%User{} = user, permissions) do
    %__MODULE__{
      user: user,
      permissions: MapSet.new(permissions)
    }
  end

  # Tangani nil dengan 2 argumen
  def for_user(nil, _permissions), do: nil

  def for_user(%User{} = user) do
    for_user(user, [])
  end

  def for_user(nil), do: nil

  @doc """
  Memeriksa apakah scope (user) memiliki permission tertentu.
  Contoh: Scope.can?(scope, "articles", "create")
  """
  def can?(%__MODULE__{permissions: permissions}, resource, action)
      when is_binary(resource) and is_binary(action) do
    MapSet.member?(permissions, "#{resource}:#{action}")
  end

  def can?(nil, _resource, _action), do: false
end
