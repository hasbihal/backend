defmodule HasbihalWeb.ConversationController do
  @moduledoc false
  use HasbihalWeb, :controller

  import Ecto.Query, only: [from: 2]
  alias Ecto.Changeset
  alias Hasbihal.Repo
  alias Hasbihal.{Conversations, Conversations.Conversation, Messages.Message, Users.User}

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
      render(conn, "index.html")
    end
  end

  @doc false
  def show(conn, %{"id" => id}) do
    conversation = Conversations.get_conversation!(id)
    render(conn, "show.html", conversation: conversation)
  end

  @doc false
  def messages(conn, %{"key" => key}) do
    messages_query = from(m in Message, order_by: [desc: :inserted_at], limit: 10)

    conversations =
      Repo.all(
        from(c in Conversation,
          distinct: true,
          left_join: u1 in assoc(c, :users),
          where: u1.id == ^conn.assigns[:current_user].id and c.key == ^key,
          preload: [messages: ^messages_query]
        )
      )

    if length(conversations) > 0 do
      conversation = List.first(conversations)

      render(conn, "show.html",
        conversation: conversation,
        messages: conversation.messages |> Enum.reverse()
      )
    else
      conn
      |> put_flash(:error, "You are not in this conversation!")
      |> redirect(to: Routes.user_path(conn, :index))
    end
  end

  def messages_seen(conn, %{"key" => key}) do
    if conn.assigns[:user_signed_in?] do
      from(m in Message,
        join: c in assoc(m, :conversation),
        where:
          c.key == ^key and is_nil(m.seen_at) and m.user_id != ^conn.assigns[:current_user].id
      )
      |> Repo.update_all(
        set: [
          seen_by_id: conn.assigns[:current_user].id,
          seen_at: NaiveDateTime.utc_now()
        ]
      )

      json(conn, %{ok: 200})
    else
      conn
      |> put_flash(:error, "You have to sign in before!")
      |> redirect(to: Routes.session_path(conn, :new))
    end
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
    key =
      24 |> :crypto.strong_rand_bytes() |> Base.url_encode64(padding: false) |> binary_part(0, 24)

    users = Repo.all(from(u in User, where: u.id in ^users))

    %Conversation{key: key}
    |> Changeset.change()
    |> Changeset.put_assoc(:users, users)
    |> Repo.insert!()
  end
end
