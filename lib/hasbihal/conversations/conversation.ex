defmodule Hasbihal.Conversations.Conversation do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "conversations" do
    field(:key, :string)
    field(:subject, :string)

    many_to_many(:users, Hasbihal.Users.User, join_through: "conversations_participants")
    has_many(:messages, Hasbihal.Messages.Message)

    timestamps()
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:key])
    |> validate_required([:key])
    |> unique_constraint(:key)
    |> cast_assoc(:users)
  end
end
