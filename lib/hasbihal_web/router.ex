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

  pipeline :browser_auth do
    plug(Guardian.Plug.VerifySession)
    plug(Guardian.Plug.LoadResource)
  end

  pipeline :auth do
    plug(Guardian.Plug.EnsureAuthenticated, handler: HasbihalWeb.AuthHandler)
  end

  scope "/", HasbihalWeb do
    # Use the default browser stack
    pipe_through([:browser])

    get("/", PageController, :index)
    get("/about", PageController, :about)

    resources("/users", UserController, except: [:index, :show])
    resources("/sessions", SessionController, only: [:new, :create])
  end

  scope "/", HasbihalWeb do
    pipe_through([:browser, :browser_auth, :auth])

    get("/", PageController, :index)

    resources("/users", UserController, only: [:index, :show])
    resources("/sessions", SessionController, only: [:delete])
  end

  # Other scopes may use custom stacks.
  # scope "/api", HasbihalWeb do
  #   pipe_through :api
  # end
end
