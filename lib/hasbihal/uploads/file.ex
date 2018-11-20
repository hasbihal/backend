defmodule Hasbihal.Uploads.File do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "files" do
    field(:file, Hasbihal.File.Type)

    belongs_to(:message, Hasbihal.Messages.Message)

    timestamps()
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, [:file, :message_id])
    |> validate_required([:file, :message_id])
  end
end
