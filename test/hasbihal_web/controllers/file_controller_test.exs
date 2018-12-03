defmodule HasbihalWeb.Api.V1.FileControllerTest do
  use HasbihalWeb.ConnCase

  alias Hasbihal.Uploads
  alias Hasbihal.Uploads.File

  @create_attrs %{
    file: "some file"
  }
  @update_attrs %{
    file: "some updated file"
  }
  @invalid_attrs %{file: nil}

  def fixture(:file) do
    {:ok, file} = Uploads.create_file(@create_attrs)
    file
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create file" do
    test "renders file when data is valid", %{conn: conn} do
      conn = post(conn, Routes.file_path(conn, :create), file: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.file_path(conn, :show, id))

      assert %{
               "id" => id,
               "file" => "some file"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.file_path(conn, :create), file: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_file(_) do
    file = fixture(:file)
    {:ok, file: file}
  end
end
