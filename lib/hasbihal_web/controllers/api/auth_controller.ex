defmodule HasbihalWeb.Api.AuthController do
  @moduledoc false
  use HasbihalWeb, :controller

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias Hasbihal.Guardian
  alias Hasbihal.{Users, Users.User}

  def signin(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case verify_credentials(email, password) do
      {:ok, user} ->
        case Guardian.encode_and_sign(user) do
          {:ok, token, _claims} ->
            conn
            |> put_status(:created)
            |> put_resp_header("location", Routes.user_path(conn, :show, user))
            |> render("token.json", token: token)

          _ ->
            conn
            |> put_status(:unauthorized)
        end

      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
    end
  end

  @doc false
  defp verify_credentials(email, password) when is_binary(email) and is_binary(password) do
    with {:ok, user} <- find_by_email(email),
         do: verify_password(password, user)
  end

  @doc false
  defp find_by_email(email) when is_binary(email) do
    case Users.get_user_by_email!(email) do
      nil ->
        dummy_checkpw()
        {:error, "User with email '#{email}' not found"}

      user ->
        {:ok, user}
    end
  end

  @doc false
  defp verify_password(password, %User{} = user) when is_binary(password) do
    if checkpw(password, user.password_encrypted) do
      {:ok, user}
    else
      {:error, :invalid_password}
    end
  end
end
