defmodule Hasbihal.Auth.CurrentUser do
  @moduledoc false

  import Plug.Conn
  import Ecto.Query, only: [from: 2]

  def init(_params) do
  end

  def call(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    messages =
      from(m in Hasbihal.Messages.Message,
        order_by: [desc: :inserted_at],
        group_by: [:id, :conversation_id],
        limit: 1
      )

    conversations = get_conversations()

    conn
    |> assign(:current_user, current_user)
    |> assign(:user_signed_in?, !is_nil(current_user))
    |> assign(:conversations, conversations)
  end

  defp get_conversations(%{assigns: %{current_user: nil}}, _params), do: []

  defp get_conversations(%{assigns: %{current_user: current_user}}, _params) do
    Hasbihal.Repo.all(
      from(c in Hasbihal.Conversations.Conversation,
        distinct: true,
        left_join: u1 in assoc(c, :users),
        inner_join: u2 in assoc(c, :users),
        where: u1.id == ^current_user.id and u2.id != ^current_user.id,
        preload: [users: u2, messages: ^messages]
      )
    )
  end
end
