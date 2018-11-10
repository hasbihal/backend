defmodule Hasbihal.Repo.Migrations.AddMissingFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :summary, :string
      add :location, :string
      add :gender, :integer
      add :avatar, :string
    end
  end
end
