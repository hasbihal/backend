defmodule Hasbihal.MessagesTest do
  use Hasbihal.DataCase

  alias Hasbihal.Users
  alias Hasbihal.Conversations
  alias Hasbihal.Messages

  describe "messages" do
    alias Hasbihal.Messages.Message

    @valid_attrs %{message: "some message", user_id: nil, conversation_id: nil}
    @update_attrs %{message: "some updated message"}
    @invalid_attrs %{message: nil}

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

    # @user user_fixture()
    # @conversation conversation_fixture()

    def message_fixture(attrs \\ %{}) do
      {:ok, message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Messages.create_message()

      message
    end

    test "list_messages/0 returns all messages" do
      message =
        message_fixture(%{user_id: user_fixture().id, conversation_id: conversation_fixture().id})

      assert Messages.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message =
        message_fixture(%{user_id: user_fixture().id, conversation_id: conversation_fixture().id})

      assert Messages.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      assert {:ok, %Message{} = message} =
               Messages.create_message(%{
                 @valid_attrs
                 | user_id: user_fixture().id,
                   conversation_id: conversation_fixture().id
               })

      assert message.message == "some message"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message =
        message_fixture(%{user_id: user_fixture().id, conversation_id: conversation_fixture().id})

      assert {:ok, %Message{} = message} = Messages.update_message(message, @update_attrs)

      assert message.message == "some updated message"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message =
        message_fixture(%{user_id: user_fixture().id, conversation_id: conversation_fixture().id})

      assert {:error, %Ecto.Changeset{}} = Messages.update_message(message, @invalid_attrs)
      assert message == Messages.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message =
        message_fixture(%{user_id: user_fixture().id, conversation_id: conversation_fixture().id})

      assert {:ok, %Message{}} = Messages.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message =
        message_fixture(%{user_id: user_fixture().id, conversation_id: conversation_fixture().id})

      assert %Ecto.Changeset{} = Messages.change_message(message)
    end
  end
end
