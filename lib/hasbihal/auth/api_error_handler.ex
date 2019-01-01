defmodule Hasbihal.Auth.ApiErrorHandler do
  @moduledoc false
  import Plug.Conn

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(401, Jason.encode!(%{"error" => "Unauthorized"}))
  end
end
