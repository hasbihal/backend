defmodule Hasbihal.Auth.CurrentUser do
  import Plug.Conn

  alias Hasbihal.Users
  alias Hasbihal.Users.User

  def init(_params) do
  end

  def call(conn, _params) do
    cond do
      current_user = Guardian.Plug.current_resource(conn) ->
        conn
        |> assign(:current_user, current_user)
        |> assign(:user_signed_in?, true)

      true ->
        conn
        |> assign(:current_user, nil)
        |> assign(:user_signed_in?, false)
    end
  end
end
