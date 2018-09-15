defmodule HasbihalWeb.PageController do
  use HasbihalWeb, :controller

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    render(conn, "index.html", current_user: current_user)
  end

  def about(conn, _params) do
    render(conn, "about.html")
  end
end
