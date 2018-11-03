defmodule Hasbihal.Conversations.Participant do
  use Ecto.Schema
  import Ecto.Changeset


  schema "conversations_participants" do
    field :conversation_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(participant, attrs) do
    participant
    |> cast(attrs, [])
    |> validate_required([])
  end
end
