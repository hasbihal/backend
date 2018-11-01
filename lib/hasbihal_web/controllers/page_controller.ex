defmodule HasbihalWeb.PageController do
  use HasbihalWeb, :controller

  import Ecto.Query, only: [from: 2]
  alias Hasbihal.{Repo, Users.User}

  def index(conn, _params) do
    %{id: current_user_id} = get_in(conn.assigns, [:current_user])

    users = Repo.all(from u in User, where: u.id != ^current_user_id)
    render(conn, "index.html", users: users)
  end

  def about(conn, _params) do
    render(conn, "about.html")
  end
end
