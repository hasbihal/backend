defmodule Hasbihal.Conversations.Conversation do
  use Ecto.Schema
  import Ecto.Changeset


  schema "conversations" do
    field :key, :string
    field :subject, :string

    # has_many :users, {"conversations_participants", Participant}, foreign_key: :user_id
    many_to_many :users, Hasbihal.Users.User, join_through: "conversations_participants"

    timestamps()
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:key, :subject])
    |> validate_required([:key, :subject])
  end
end
