defmodule HasbihalWeb.Api.V1.UserController do
  @moduledoc false
  use HasbihalWeb, :controller

  alias Hasbihal.Users
  alias Hasbihal.{Email, Mailer, Users}

  action_fallback(HasbihalWeb.Api.V1.FallbackController)

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.json", users: users)
  end

  def me(conn, _params) do
    IO.inspect(conn.assigns)
    HasbihalWeb.Api.V1.UserController.show(conn, %{"id" => conn.assigns[:current_user].id})
  end

  def show(conn, %{"id" => id} = _params) do
    user = Users.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Users.create_user(user_params) do
      if get_in(user_params, ["avatar"]) do
        Users.update_user(user, %{avatar: user_params["avatar"]})
      end

      user.email
      |> Email.confirmation_mail(Users.generate_confirmation_token!(user))
      |> Mailer.deliver_now()

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end
end
