defmodule Hasbihal.Uploads.File do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "files" do
    field(:file, Hasbihal.File.Type)
    field(:user_id, :id)
    field(:conversation_id, :id)

    timestamps()
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, [:file])
    |> validate_required([:file])
  end
end
