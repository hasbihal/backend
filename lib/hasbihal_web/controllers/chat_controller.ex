defmodule HasbihalWeb.ChatController do
  use HasbihalWeb, :controller

  alias Hasbihal.Users

  def index(conn, %{"id" => id}) do
    cond do
      !is_nil(conn.assigns[:current_user]) && conn.assigns[:current_user].id == id ->
        conn
          |> put_flash(:info, "You cannot send messages to yourself.")
          |> redirect(to: Routes.user_path(conn, :index))
        true ->
          render(conn, "index.html", user: Users.get_user!(id))
    end
  end
end
