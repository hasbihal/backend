defmodule HasbihalWeb.ConversationController do
  @moduledoc false
  use HasbihalWeb, :controller

  import Ecto.Query, only: [from: 2]

  alias Hasbihal.Repo
  alias Hasbihal.{Conversations, Conversations.Conversation, Users.User}

  @doc false
  def index(conn, params) do
    if uid = get_in(params, ["uid"]) do
      users = [uid, conn.assigns[:current_user].id]
      conversations = get_conversations_for(List.first(users), List.last(users))

      conversation =
        if length(conversations) > 0 do
          hd(conversations)
        else
          create_new_conversation_for(users)
        end

      conn
      |> redirect(to: Routes.message_path(conn, :messages, conversation.key))
    else
      conversations = Conversations.list_conversations()
      render(conn, "index.html", conversations: conversations)
    end
  end

  @doc false
  def show(conn, %{"id" => id}) do
    conversation = Conversations.get_conversation!(id)
    render(conn, "show.html", conversation: conversation)
  end

  @doc false
  def messages(conn, %{"key" => key}) do
    conversation = Conversations.get_conversation_by_key!(key)
    render(conn, "show.html", conversation: conversation)
  end

  @doc false
  defp get_conversations_for(cuid, uid) do
    Repo.all(
      from(c in Conversation,
        distinct: true,
        left_join: u1 in assoc(c, :users),
        inner_join: u2 in assoc(c, :users),
        on: u2.id == ^uid,
        where: u1.id == ^cuid
      )
    )
  end

  @doc false
  defp create_new_conversation_for(users) do
    key = :crypto.strong_rand_bytes(24) |> Base.url_encode64() |> binary_part(0, 24)

    users = Repo.all(from(u in User, where: u.id in ^users))

    %Conversation{key: key}
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:users, users)
    |> Repo.insert!()
  end
end
