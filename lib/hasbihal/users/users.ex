defmodule Hasbihal.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Phoenix.Token
  alias Hasbihal.{Repo, Users.User}

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(
      from(u in User,
        where: is_nil(u.confirmed_at) == false
      )
    )
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user by email.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user_email!("user@example.com")
      %User{}

      iex> get_user_email!("user@example.com")
      ** (Ecto.NoResultsError)

  """
  def get_user_by_email!(email), do: Repo.get_by(User, email: email)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.insert_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.update_changeset(user, %{})
  end

  @doc false
  def generate_confirmation_token!(%User{} = user) do
    Token.sign(HasbihalWeb.Endpoint, "user_id", user.id)
  end

  @doc false
  def verify_confirmation_token!(token) do
    Token.verify(HasbihalWeb.Endpoint, "user_id", token)
  end

  @doc """
  Updates an User's confirmed_at field as utc_now.

  ## Examples

      iex> confirm_user!(user)

  """
  def confirm_user!(%User{} = user) do
    update_user(user, %{confirmed_at: NaiveDateTime.utc_now()})
  end

  @doc """
  Updates an User's confirmed_at field as nil.

  ## Examples

      iex> unconfirm_user!(user)

  """
  def unconfirm_user!(%User{} = user) do
    update_user(user, %{confirmed_at: nil})
  end
end
