defmodule HasbihalWeb.Api.UserController do
  @moduledoc false
  use HasbihalWeb, :controller

  alias Hasbihal.Users

  @doc false
  def index(conn, _params) do
    users = Users.list_users()

    render(conn, "index.json", users: users)
  end
end
