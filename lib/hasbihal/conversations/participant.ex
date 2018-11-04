defmodule Hasbihal.Conversations.Participant do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "conversations_participants" do
    belongs_to(:conversation, Hasbihal.Conversations.Conversation)
    belongs_to(:user, Hasbihal.Users.User)
  end

  @doc false
  def changeset(participant, attrs) do
    participant
    |> cast(attrs, [:conversation_id, :user_id])
    |> validate_required([:conversation_id, :user_id])
  end
end
