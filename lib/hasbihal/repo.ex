defmodule Hasbihal.Repo do
  use Ecto.Repo,
    otp_app: :hasbihal,
    adapter: Ecto.Adapters.Postgres
end
