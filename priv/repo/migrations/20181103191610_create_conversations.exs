defmodule Hasbihal.Repo.Migrations.CreateConversations do
  use Ecto.Migration

  def change do
    create table(:conversations) do
      add :key, :string
      add :subject, :string

      timestamps()
    end
  end
end
