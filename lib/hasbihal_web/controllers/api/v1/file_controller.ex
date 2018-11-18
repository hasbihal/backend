defmodule HasbihalWeb.Api.V1.FileController do
  use HasbihalWeb, :controller

  alias Hasbihal.Uploads
  alias Hasbihal.Uploads.File

  action_fallback(HasbihalWeb.Api.V1.FallbackController)

  def index(conn, _params) do
    files = Uploads.list_files()
    render(conn, "index.json", files: files)
  end

  def create(conn, %{"file" => file_params}) do
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

  def update(conn, %{"id" => id, "file" => file_params}) do
    file = Uploads.get_file!(id)

    with {:ok, %File{} = file} <- Uploads.update_file(file, file_params) do
      render(conn, "show.json", file: file)
    end
  end

  def delete(conn, %{"id" => id}) do
    file = Uploads.get_file!(id)

    with {:ok, %File{}} <- Uploads.delete_file(file) do
      send_resp(conn, :no_content, "")
    end
  end
end
