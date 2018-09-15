defmodule HasbihalWeb.AuthHandler do
  @moduledoc """
  """
  use HasbihalWeb, :controller

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "Authentication required")
    |> redirect(to: session_path(conn, :new))
  end
end
