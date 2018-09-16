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
end
