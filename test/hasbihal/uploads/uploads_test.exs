defmodule Hasbihal.UploadsTest do
  use Hasbihal.DataCase

  alias Hasbihal.Users
  alias Hasbihal.Conversations
  alias Hasbihal.Messages
  alias Hasbihal.Uploads

  describe "files" do
    alias Hasbihal.Uploads.File, as: MyFile

    @valid_attrs %{
      file: %Plug.Upload{
        content_type: "image/jpeg",
        filename: "avatar.jpg",
        path: File.cwd!() <> "/test/fixtures/avatar.jpg"
      }
    }
    @update_attrs %{file: "some updated file"}
    @invalid_attrs %{file: nil}

    def user_fixture do
      {:ok, user} =
        Users.create_user(%{
          name: "some user",
          email: "some@user.com",
          password: "12345678",
          password_confirmation: "12345678"
        })

      user
    end

    def conversation_fixture do
      {:ok, conversation} =
        Conversations.create_conversation(%{
          key: "some user"
        })

      conversation
    end

    def message_fixture do
      {:ok, message} =
        Messages.create_message(%{
          message: "some message",
          user: user_fixture().id,
          conversation: conversation_fixture().id
        })

      message
    end

    def file_fixture(attrs \\ %{}) do
      {:ok, file} =
        attrs
        |> Enum.into(%{@valid_attrs | message_id: message_fixture().id})
        |> Uploads.create_file()

      file
    end

    test "list_files/0 returns all files" do
      file = file_fixture()
      assert Uploads.list_files() == [file]
    end

    test "get_file!/1 returns the file with given id" do
      file = file_fixture()
      assert Uploads.get_file!(file.id) == file
    end

    test "create_file/1 with valid data creates a file" do
      assert {:ok, %MyFile{} = file} = Uploads.create_file(@valid_attrs)
      assert file.file == "some file"
    end

    test "create_file/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Uploads.create_file(@invalid_attrs)
    end

    test "update_file/2 with valid data updates the file" do
      file = file_fixture()
      assert {:ok, %MyFile{} = file} = Uploads.update_file(file, @update_attrs)
      assert file.file == "some updated file"
    end

    test "update_file/2 with invalid data returns error changeset" do
      file = file_fixture()
      assert {:error, %Ecto.Changeset{}} = Uploads.update_file(file, @invalid_attrs)
      assert file == Uploads.get_file!(file.id)
    end

    test "delete_file/1 deletes the file" do
      file = file_fixture()
      assert {:ok, %MyFile{}} = Uploads.delete_file(file)
      assert_raise Ecto.NoResultsError, fn -> Uploads.get_file!(file.id) end
    end

    test "change_file/1 returns a file changeset" do
      file = file_fixture()
      assert %Ecto.Changeset{} = Uploads.change_file(file)
    end
  end
end
