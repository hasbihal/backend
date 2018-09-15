defmodule Hasbihal.Guardian do
  use Guardian, otp_app: :hasbihal

  alias Hasbihal.Users
  alias Hasbihal.Users.User

  def subject_for_token(user = %User{}, _claims) do
    # You can use any value for the subject of your token but
    # it should be useful in retrieving the resource later, see
    # how it being used on `resource_from_claims/1` function.
    # A unique `id` is a good subject, a non-unique email address
    # is a poor subject.
    sub = to_string(user.id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, "Unknown resource type"}
  end

  def resource_from_claims(claims) do
    # Here we'll look up our resource from the claims, the subject can be
    # found in the `"sub"` key. In `above subject_for_token/2` we returned
    # the resource id so here we'll rely on that to look it up.
    id = claims["sub"]
    resource = Users.get_user!(id)
    {:ok, resource}
  end

  def resource_from_claims(_claims) do
    {:error, "Unknown resource type"}
  end
end
