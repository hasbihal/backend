defmodule HasbihalWeb.Router do
  use HasbihalWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug(Hasbihal.Auth.Pipeline)
    plug(Hasbihal.Auth.CurrentUser)
    plug(:put_user_token)
  end

  pipeline :api_auth do
    plug(Hasbihal.Auth.ApiPipeline)
    plug(Hasbihal.Auth.CurrentUser)
  end

  pipeline :ensure_auth do
    plug(Guardian.Plug.EnsureAuthenticated)
  end

  scope "/", HasbihalWeb do
    pipe_through([:browser, :auth])

    get("/", PageController, :index)
    get("/about", PageController, :about)

    get("/users/verify/:token", UserController, :verify)
    resources("/users", UserController, only: [:index, :new, :create])
    resources("/sessions", SessionController, only: [:new, :create])
  end

  scope "/", HasbihalWeb do
    pipe_through([:browser, :auth, :ensure_auth])

    resources("/users", UserController, only: [:index, :show, :edit, :update])

    resources("/sessions", SessionController, only: [:delete])

    resources("/conversations", ConversationController, only: [:index, :show])

    get("/messages/:key", ConversationController, :messages, as: :message)
    patch("/messages/:key/seen", ConversationController, :messages_seen, as: :message_seen)
  end

  # Other scopes may use custom stacks.
  scope "/api", HasbihalWeb.Api do
    pipe_through([:api, :api_auth])

    post("/auth/signup", V1.UserController, :create)
    post("/auth/signin", AuthController, :signin)
  end

  scope "/api/v1", HasbihalWeb.Api.V1 do
    pipe_through([:api, :api_auth])

    get("/me", UserController, :me)

    resources("/users", UserController, only: [:new, :create, :edit, :delete])

    resources("/files", FileController, only: [:show, :create])
  end

  if Mix.env == :dev do
    forward "/emails", Bamboo.SentEmailViewerPlug
  end

  defp put_user_token(conn, _) do
    if current_user = conn.assigns[:current_user] do
      user_id_token = Phoenix.Token.sign(conn, "user_id", current_user.id)

      conn
      |> assign(:user_id, user_id_token)
    else
      conn
      |> assign(:user_id, nil)
    end
  end
end
