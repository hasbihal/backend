defmodule HasbihalWeb.ConversationController do
  use HasbihalWeb, :controller

  import Ecto.Query, only: [from: 2]

  alias Hasbihal.Repo
  alias Hasbihal.{Conversations, Conversations.Conversation}

  def index(conn, params) do
    if uid = get_in(params, ["uid"]) do
      conversations = get_conversations_for(uid)
      conversation =
        if length(conversations) > 0 do
          hd(conversations)
        else
          key = :crypto.strong_rand_bytes(24) |> Base.url_encode64 |> binary_part(0, 24)
          {:ok, c} = Conversations.create_conversation(%{key: key, subject: key})
          c
        end

        IO.inspect conversation
      conn
      |> redirect(to: Routes.message_path(conn, :show, key: conversation.key))
    else
      conversations = Conversations.list_conversations
      render(conn, "index.html", conversations: conversations)
    end
  end

  def show(conn, %{"id" => id}) do
    conversation = Conversations.get_conversation!(id)
    render(conn, "show.html", conversation: conversation)
  end

  def show(conn, %{"key" => key}) do
    IO.inspect("here")
    conversation = Conversations.get_conversation_by_key!(key)
    render(conn, "show.html", conversation: conversation)
  end

  defp get_conversations_for(uid) do
    Repo.all(from c in Conversation, left_join: u in assoc(c, :users), where: u.id == ^uid, select: {c, u})
  end
end
