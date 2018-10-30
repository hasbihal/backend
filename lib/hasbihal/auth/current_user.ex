defmodule Hasbihal.Auth.CurrentUser do
  @moduledoc false

  import Plug.Conn

  def init(_params) do
  end

  def call(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    conn
    |> assign(:current_user, current_user)
    |> assign(:user_signed_in?, !is_nil(current_user))
  end
end
