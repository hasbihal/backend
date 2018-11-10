defmodule Hasbihal.Repo.Migrations.AddSeenByToMessages do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :seen_by_id, references(:users, on_delete: :nothing), null: true, default: nil
      add :seen_at, :naive_datetime, null: true, default: nil
    end

    create index(:messages, [:seen_by_id])
  end
end
