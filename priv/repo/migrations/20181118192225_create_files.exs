defmodule Hasbihal.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files) do
      add :file, :string
      add :message_id, references(:messages, on_delete: :delete_all)

      timestamps()
    end

    create index(:files, [:message_id])
  end
end
