defmodule HasbihalWeb.UserController do
  use HasbihalWeb, :controller

  alias Hasbihal.Guardian.Plug, as: GuardianPlug
  alias Hasbihal.Users
  alias Hasbihal.Users.User

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, _params) do
    changeset = Users.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> GuardianPlug.sign_in(user)
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  # def show(conn, _params) do
  #   render(conn, "show.html")
  # end

  # def edit(conn, %{"id" => id}) do
  #   user = Users.get_user!(id)
  #   changeset = Users.change_user(user)
  #   render(conn, "edit.html", user: user, changeset: changeset)
  # end

  # def update(conn, %{"id" => id, "user" => user_params}) do
  #   user = Users.get_user!(id)

  #   case Users.update_user(user, user_params) do
  #     {:ok, user} ->
  #       conn
  #       |> put_flash(:info, "User updated successfully.")
  #       |> redirect(to: Routes.user_path(conn, :show, user))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html", user: user, changeset: changeset)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   user = Users.get_user!(id)
  #   {:ok, _user} = Users.delete_user(user)

  #   conn
  #   |> put_flash(:info, "User deleted successfully.")
  #   |> redirect(to: Routes.user_path(conn, :index))
  # end
end
