defmodule HasbihalWeb.PageController do
  use HasbihalWeb, :controller

  @doc false
  def index(conn, _params) do
    render(conn, "index.html")
  end

  @doc false
  def about(conn, _params) do
    render(conn, "about.html")
  end
end
