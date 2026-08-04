defmodule ForumidWeb.ArticleLive.Form do
  use ForumidWeb, :live_view

  alias Forumid.Content
  alias Forumid.Content.Article

  @impl true
  def mount(%{"slug" => slug} = _params, _session, socket) do
    article = Content.get_article_by_slug!(slug)
    changeset = Content.change_article(article)

    {:ok,
     socket
     |> assign(:article, article)
     |> assign(:form, to_form(changeset))
     |> assign(:page_title, "Edit Article")}
  end

  def mount(_params, _session, socket) do
    changeset = Content.change_article(%Article{})

    {:ok,
     socket
     |> assign(:article, %Article{})
     |> assign(:form, to_form(changeset))
     |> assign(:page_title, "New Article")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
      </.header>

      <.form
        for={@form}
        id="article-form"
        phx-change="validate"
        phx-submit="save"
        class="space-y-4 mt-6"
      >
        <.input field={@form[:title]} label="Title" />
        <.input field={@form[:slug]} label="Slug" />
        <.input field={@form[:excerpt]} label="Excerpt" />
        <.input field={@form[:content]} type="textarea" label="Content" />
        <.input
          field={@form[:status]}
          type="select"
          options={["draft", "published", "archived"]}
          label="Status"
        />

        <div class="mt-4">
          <.button type="submit" phx-disable-with="Saving...">Save Article</.button>
        </div>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def handle_event("validate", %{"article" => params}, socket) do
    changeset =
      socket.assigns.article
      |> Content.change_article(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("save", %{"article" => params}, socket) do
    user = socket.assigns.current_scope.user

    # Set author_id otomatis dari user yang sedang login
    params = Map.put(params, "author_id", user.id)

    case save_article(socket.assigns.article, params) do
      {:ok, _article} ->
        {:noreply,
         socket
         |> put_flash(:info, "Article saved successfully")
         |> push_navigate(to: ~p"/articles")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp save_article(%Article{} = article, params) do
    if article.id do
      Content.update_article(article, params)
    else
      Content.create_article(params)
    end
  end
end
