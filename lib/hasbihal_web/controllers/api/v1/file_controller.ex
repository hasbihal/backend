defmodule HasbihalWeb.Api.V1.FileController do
  use HasbihalWeb, :controller

  alias Hasbihal.Uploads
  alias Hasbihal.Uploads.File

  action_fallback(HasbihalWeb.Api.V1.FallbackController)

  def create(conn, %{"file" => file_params}) do
    conversation =
      Hasbihal.Conversations.get_conversation_by_key!(file_params["conversation_key"])

    user = Hasbihal.Users.get_user_by_token!(file_params["user_token"])

    {:ok, message} =
      Hasbihal.Messages.create_message(%{
        user_id: user.id,
        conversation_id: conversation.id,
        message: "<p>#{file_params["file"].filename}</p>"
      })

    file_params = Map.merge(file_params, %{"message_id" => message.id})

    with {:ok, %File{} = file} <- Uploads.create_file(file_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.file_path(conn, :show, file))
      |> render("show.json", file: file)
    end
  end

  def show(conn, %{"id" => id}) do
    file = Uploads.get_file!(id)
    render(conn, "show.json", file: file)
  end
end
