defmodule HasbihalWeb.ChatController do
  use HasbihalWeb, :controller

  alias Hasbihal.Users

  def index(conn, params) do
    user = Users.get_user!(params["id"])
    render(conn, "index.html", user: user)
  end
end
