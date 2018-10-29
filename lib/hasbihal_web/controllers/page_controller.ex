defmodule HasbihalWeb.PageController do
  use HasbihalWeb, :controller

  alias Hasbihal.Users

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.html", users: users)
  end

  def about(conn, _params) do
    render(conn, "about.html")
  end
end
