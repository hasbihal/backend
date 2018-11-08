defmodule Hasbihal.Auth.ErrorHandler do
  @moduledoc false

  import Phoenix.Controller
  alias HasbihalWeb.Router.Helpers, as: Routes

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_flash(:error, "Please sign in first.")
    |> redirect(to: Routes.session_path(conn, :new, ref: conn.request_path))
  end
end
