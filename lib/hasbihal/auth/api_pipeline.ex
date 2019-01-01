defmodule Hasbihal.Auth.ApiPipeline do
  @moduledoc false

  use Guardian.Plug.Pipeline,
    otp_app: :hasbihal,
    module: Hasbihal.Guardian,
    error_handler: Hasbihal.Auth.ApiErrorHandler

  plug(Guardian.Plug.VerifyHeader)
  plug(Guardian.Plug.LoadResource, allow_blank: true)
  plug(Guardian.Plug.EnsureAuthenticated)
end
