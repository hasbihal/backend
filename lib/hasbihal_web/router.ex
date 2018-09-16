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

  pipeline :ensure_auth do
    plug(Guardian.Plug.EnsureAuthenticated)
  end

  scope "/", HasbihalWeb do
    # Use the default browser stack
    pipe_through([:browser, :auth])

    get("/", PageController, :index)
    get("/about", PageController, :about)

    resources("/users", UserController, except: [:index, :show])
    resources("/sessions", SessionController, only: [:new, :create])

    get("/rooms/:id", RoomController, :index)
  end

  scope "/", HasbihalWeb do
    pipe_through([:browser, :auth, :ensure_auth])

    get("/", PageController, :index)

    resources("/users", UserController, only: [:index, :show])
    resources("/sessions", SessionController, only: [:delete])
  end

  # Other scopes may use custom stacks.
  # scope "/api", HasbihalWeb do
  #   pipe_through :api
  # end

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
