defmodule Hasbihal.Messages.Message do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field(:message, :string)
    field(:seen_by_id, :integer)
    field(:seen_at, :naive_datetime)

    belongs_to(:user, Hasbihal.Users.User)
    belongs_to(:conversation, Hasbihal.Conversations.Conversation)
    has_one(:file, Hasbihal.Uploads.File)

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:message, :user_id, :conversation_id, :seen_by_id, :seen_at])
    |> validate_required([:message, :user_id, :conversation_id])
    |> cast_assoc(:user)
    |> cast_assoc(:conversation)
    |> cast_assoc(:file)
  end
end
