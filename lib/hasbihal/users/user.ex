defmodule Hasbihal.Users.User do
  @moduledoc false

  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt

  schema "users" do
    field(:email, :string)
    field(:confirmed_at, :naive_datetime)
    field(:name, :string)
    field(:summary, :string)
    field(:location, :string)
    field(:gender, :integer)
    field(:avatar, Hasbihal.Avatar.Type)
    field(:password_encrypted, :string)

    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)

    many_to_many(:conversations, Hasbihal.Conversations.Conversation,
      join_through: "conversations_participants"
    )

    has_many(:messages, Hasbihal.Messages.Message)

    timestamps()
  end

  @permitted_params [
    :name,
    :email,
    :confirmed_at,
    :password,
    :password_confirmation,
    :summary,
    :location,
    :gender
  ]

  @required_params [
    :name,
    :email,
    :password,
    :password_confirmation
  ]

  @doc """
  Changeset definition for creating users
  """
  def insert_changeset(user, params) do
    user
    |> cast(params, @permitted_params)
    |> cast_attachments(params, [:avatar])
    |> validate_required(@required_params)
    |> validate_email()
    |> validate_password()
  end

  @doc """
  Changeset definition for updating users
  """
  def update_changeset(user, params) do
    user
    |> cast(params, @permitted_params)
    |> cast_attachments(params, [:avatar])
    |> validate_email()
    |> validate_password()
  end

  @doc false
  defp validate_email(changeset) do
    email = get_change(changeset, :email)

    if is_nil(email) do
      changeset
    else
      changeset
      |> validate_format(
        :email,
        ~r/^[a-zA-Z0-9_+&*-]+(?:\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$/
      )
      |> unique_constraint(:email)
    end
  end

  @doc false
  defp validate_password(changeset) do
    password = get_change(changeset, :password)

    if is_nil(password) do
      changeset
    else
      changeset
      |> validate_length(:password, min: 8)
      |> validate_confirmation(:password)
      |> encrypt_password()
    end
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
