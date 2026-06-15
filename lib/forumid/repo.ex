defmodule Forumid.Repo do
  use Ecto.Repo,
    otp_app: :forumid,
    adapter: Ecto.Adapters.MyXQL
end
