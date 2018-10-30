defmodule Hasbihal.Users.User do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt

  schema "users" do
    field(:email, :string)
    field(:name, :string)
    field(:password_encrypted, :string)

    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :password_confirmation])
    |> validate_required([:name, :email, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> encrypt_password()
    |> unique_constraint(:email)
  end

  defp encrypt_password(%{valid?: false} = changeset), do: changeset

  defp encrypt_password(%{valid?: true} = changeset) do
    encrypted_password =
      changeset
      |> get_field(:password)
      |> Bcrypt.hashpwsalt()

    changeset
    |> put_change(:password_encrypted, encrypted_password)
  end
end