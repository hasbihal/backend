defmodule Hasbihal.Auth.CurrentUser do
  @moduledoc false

  import Plug.Conn

  def init(_params) do
  end

  def call(conn, _params) do
    if current_user = Guardian.Plug.current_resource(conn) do
      conn
      |> assign(:current_user, current_user)
      |> assign(:user_signed_in?, true)
    else
      conn
      |> assign(:current_user, nil)
      |> assign(:user_signed_in?, false)
    end
  end
end
