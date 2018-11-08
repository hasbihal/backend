defmodule Hasbihal.Guardian do
  @moduledoc false

  use Guardian, otp_app: :hasbihal

  alias Hasbihal.Users
  alias Hasbihal.Users.User

  @doc false
  def subject_for_token(%User{} = subject, _claims) do
    # You can use any value for the subject of your token but
    # it should be useful in retrieving the resource later, see
    # how it being used on `resource_from_claims/1` function.
    # A unique `id` is a good subject, a non-unique email address
    # is a poor subject.
    {:ok, to_string(subject.id)}
  end

  @doc false
  def subject_for_token(_, _) do
    {:error, "Unknown resource type"}
  end

  @doc false
  def resource_from_claims(%{"sub" => id} = _claims) do
    # Here we'll look up our resource from the claims, the subject can be
    # found in the `"sub"` key. In `above subject_for_token/2` we returned
    # the resource id so here we'll rely on that to look it up.
    resource = Users.get_user!(id)
    {:ok, resource}
  end

  @doc false
  def resource_from_claims(%{}) do
    {:error, "Unknown resource type"}
  end
end
