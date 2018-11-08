defmodule Hasbihal.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :message, :text
      add :user_id, references(:users, on_delete: :nothing)
      add :conversation_id, references(:conversations, on_delete: :nothing)

      timestamps()
    end

    create index(:messages, [:user_id])
    create index(:messages, [:conversation_id])
  end
end
