defmodule ForumidWeb.Router do
  use ForumidWeb, :router

  import ForumidWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ForumidWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # 1. Authenticated routes (Harus di atas route public /articles/:slug)
  scope "/", ForumidWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{ForumidWeb.UserAuth, :require_authenticated}] do
      live "/users/profile/edit", ProfileLive.Edit, :edit
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email
    end

    live_session :require_article_permission,
      on_mount: [
        {ForumidWeb.UserAuth, :require_authenticated},
        {ForumidWeb.UserAuth, {:require_permission, "articles", "create"}}
      ] do
      live "/articles", ArticleLive.Index, :index
      live "/articles/new", ArticleLive.Form, :new
      live "/articles/:slug/edit", ArticleLive.Form, :edit
    end

    post "/users/update-password", UserSessionController, :update_password
  end

  scope "/moderation", ForumidWeb do
    pipe_through [:browser, :require_authenticated_user]

    # live_session :require_moderation_permission,
    #   on_mount: [
    #     {ForumidWeb.UserAuth, :require_authenticated},
    #     {ForumidWeb.UserAuth, {:require_permission, "audit", "read"}}
    #   ] do
    #   live "/moderation", ModerationLive.Index, :index
    # end

    resources "/activity_logs", ActivityLogController, only: [:index, :show]
  end

  # 2. Public routes (Ditaruh ke bawah agar /articles/new tidak tertangkap di sini)
  scope "/", ForumidWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/@:username", ProfileLive.Show, :show
    get "/articles/:slug", ArticleController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", ForumidWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:forumid, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ForumidWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  # 3. Authentication routes (Login, Register, Logout)
  scope "/", ForumidWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{ForumidWeb.UserAuth, :mount_current_scope}] do
      live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :new
      live "/users/log-in/:token", UserLive.Confirmation, :new
    end

    post "/users/log-in", UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete
  end
end
