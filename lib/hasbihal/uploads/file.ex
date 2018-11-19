defmodule Hasbihal.Uploads.File do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "files" do
    field(:file, Hasbihal.File.Type)

    field(:user_id, :integer)
    field(:conversation_id, :integer)

    timestamps()
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, [:file, :conversation_id, :user_id])
    |> validate_required([:file, :conversation_id, :user_id])
  end
end
