defmodule HasbihalWeb.SessionController do
  @moduledoc false
  use HasbihalWeb, :controller

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias Hasbihal.Guardian.Plug, as: GuardianPlug
  alias Hasbihal.Users
  alias Hasbihal.Users.User

  plug(:redirect_if_signed_in when action not in [:delete])

  @doc false
  def new(conn, _params) do
    render(conn, "new.html")
  end

  @doc false
  def create(conn, %{"session" => %{"email" => "", "password" => ""}}) do
    conn
    |> put_flash(:error, "Please fill in an email address and password")
    |> render("new.html")
  end

  @doc false
  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case verify_credentials(email, password) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully signed in")
        |> GuardianPlug.sign_in(user)
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid email address or password")
        |> render("new.html")
    end
  end

  @doc false
  def delete(conn, _params) do
    conn
    |> GuardianPlug.sign_out()
    |> put_flash(:info, "Successfully signed out")
    |> redirect(to: Routes.page_path(conn, :index))
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

  @doc false
  defp redirect_if_signed_in(%{assigns: %{user_signed_in?: true}} = conn, _params) do
    conn
    |> put_flash(:info, "Already signed in!")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  @doc false
  defp redirect_if_signed_in(conn, _params), do: conn
end
