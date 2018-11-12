defmodule Hasbihal.Repo.Migrations.AddConfirmedAtToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :confirmed_at, :naive_datetime, null: true, default: nil
    end
  end
end
