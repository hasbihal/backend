defmodule HasbihalWeb.PageController do
  use HasbihalWeb, :controller

  import Ecto.Query, only: [from: 2]
  alias Hasbihal.{Repo, Users, Users.User}

  def index(conn, _params) do
    users =
      if current_user = conn.assigns[:current_user] do
        Repo.all(from u in User, where: u.id != ^current_user.id)
      else
        Users.list_users
      end
    render(conn, "index.html", users: users)
  end

  def about(conn, _params) do
    render(conn, "about.html")
  end
end
