defmodule HasbihalWeb.ChatController do
  use HasbihalWeb, :controller

  alias Hasbihal.Users
  alias Hasbihal.Conversations

  def index(conn, %{"id" => id}) do
    cond do
      !is_nil(conn.assigns[:current_user]) && conn.assigns[:current_user].id == id ->
        conn
          |> put_flash(:info, "You cannot send messages to yourself.")
          |> redirect(to: Routes.user_path(conn, :index))
        true ->
          key = ""
          if !is_there_a_conversation() do
            key = :crypto.strong_rand_bytes(24) |> Base.url_encode64 |> binary_part(0, 24)
            Conversations.create_conversation(%{key: key, subject: key})
          end

          conn
            |> redirect(to: Routes.chat_path(conn, :show, key: key))
    end
  end

  def show(conn, %{"key" => key}) do
    conversation = Conversations.get_conversation_by_key!(key)
    render(conn, "index.html", conversation: conversation)
  end

  # todo: check is there a conversation between the current user and other
  # if there is not a conversation create one
  defp is_there_a_conversation do false end
end
