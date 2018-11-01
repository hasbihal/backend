defmodule HasbihalWeb.ChatController do
  use HasbihalWeb, :controller

  alias Hasbihal.Users

  def index(conn, %{"id" => id}) do
    %{id: current_user_id} = get_in(conn.assigns, [:current_user])

    cond do
      to_string(current_user_id) == id ->
        conn
          |> put_flash(:info, "You cannot send messages to yourself.")
          |> redirect(to: Routes.user_path(conn, :index))
      true ->
        render(conn, "index.html", user: Users.get_user!(id))
    end
  end
end
