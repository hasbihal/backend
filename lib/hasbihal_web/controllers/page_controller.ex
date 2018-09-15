defmodule HasbihalWeb.PageController do
  use HasbihalWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
