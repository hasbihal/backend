defmodule Hasbihal.Repo.Migrations.CreateConversationsParticipants do
  use Ecto.Migration

  def change do
    create table(:conversations_participants) do
      add :conversation_id, references(:conversations, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:conversations_participants, [:conversation_id])
    create index(:conversations_participants, [:user_id])
  end
end
