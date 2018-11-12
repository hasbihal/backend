defmodule Hasbihal.Users.User do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt

  schema "users" do
    field(:email, :string)
    field(:confirmed_at, :naive_datetime)
    field(:name, :string)
    field(:summary, :string)
    field(:location, :string)
    field(:gender, :integer)
    field(:avatar, :string)
    field(:password_encrypted, :string)

    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)

    many_to_many(:conversations, Hasbihal.Conversations.Conversation,
      join_through: "conversations_participants"
    )

    has_many(:messages, Hasbihal.Messages.Message)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :name,
      :email,
      :confirmed_at,
      :password,
      :password_confirmation,
      :summary,
      :location,
      :gender,
      :avatar
    ])
    |> validate_required([:name, :email, :password, :password_confirmation])
    |> validate_format(
      :email,
      ~r/^[a-zA-Z0-9_+&*-]+(?:\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$/
    )
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> encrypt_password()
    |> unique_constraint(:email)
  end

  @doc false
  defp encrypt_password(%{valid?: false} = changeset), do: changeset

  @doc false
  defp encrypt_password(%{valid?: true} = changeset) do
    encrypted_password =
      changeset
      |> get_field(:password)
      |> Bcrypt.hashpwsalt()

    changeset
    |> put_change(:password_encrypted, encrypted_password)
  end
end
