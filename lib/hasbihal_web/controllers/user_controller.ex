defmodule HasbihalWeb.UserController do
  @moduledoc false
  use HasbihalWeb, :controller

  import Ecto.Query, only: [from: 2]
  alias Hasbihal.Guardian.Plug, as: GuardianPlug
  alias Hasbihal.{Email, Mailer, Repo, Users, Users.User}

  @doc false
  def index(conn, _params) do
    users =
      if current_user = conn.assigns[:current_user] do
        Repo.all(
          from(u in User,
            where: is_nil(u.confirmed_at) == false and u.id != ^current_user.id
          )
        )
      else
        Users.list_users()
      end

    render(conn, "index.html", users: users)
  end

  @doc false
  def new(conn, _params) do
    changeset = Users.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  @doc false
  def create(conn, %{"user" => user_params}) do
    bucket = System.get_env("BUCKET_NAME")
    region = System.get_env("AWS_REGION")
    uuid = Ecto.UUID.generate()
    avatar = user_params["avatar"]
    extension = Path.extname(avatar.filename)
    filename = "#{uuid}#{extension}"

    case Users.create_user(%{
           user_params
           | "avatar" => "https://s3.#{region}.amazonaws.com/#{bucket}/#{filename}"
         }) do
      {:ok, user} ->
        Email.confirmation_mail(user.email, Users.generate_confirmation_token!(user))
        |> Mailer.deliver_now()

        ExAws.S3.put_object(bucket, filename, File.read!(avatar.path))
        |> ExAws.request!()

        conn
        |> put_flash(:info, "User created successfully.")
        |> GuardianPlug.sign_in(user)
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  @doc false
  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.html", user: user)
  end

  @doc false
  def edit(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    changeset = Users.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    case Users.update_user(user, user_params) do
      {:ok, user} ->
        # if upload = user_params["avatar"] do
        #   extension = Path.extname(upload.filename)
        #   File.cp(upload.path, "/#{user.id}-profile#{extension}")
        # end

        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def verify(conn, %{"token" => token}) do
    case Users.verify_confirmation_token!(token) do
      {:ok, user_id} ->
        user = Users.get_user!(user_id)
        Users.confirm_user!(user)

        conn
        |> put_flash(
          :info,
          "#{String.trim(user.name)}, your account was confirmed!"
        )
        |> GuardianPlug.sign_in(user)
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, reason} ->
        conn
        |> put_flash(:info, reason)
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  # def delete(conn, %{"id" => id}) do
  #   user = Users.get_user!(id)
  #   {:ok, _user} = Users.delete_user(user)

  #   conn
  #   |> put_flash(:info, "User deleted successfully.")
  #   |> redirect(to: Routes.user_path(conn, :index))
  # end
end
