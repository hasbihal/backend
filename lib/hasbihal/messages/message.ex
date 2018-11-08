defmodule Hasbihal.Messages.Message do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field(:message, :string)

    belongs_to(:user, Hasbihal.Users.User)
    belongs_to(:conversation, Hasbihal.Conversations.Conversation)

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:message, :user_id, :conversation_id])
    |> validate_required([:message, :user_id, :conversation_id])
    |> cast_assoc(:user)
    |> cast_assoc(:conversation)
  end
end
