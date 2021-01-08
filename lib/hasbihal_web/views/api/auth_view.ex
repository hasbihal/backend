defmodule HasbihalWeb.Api.AuthView do
  use HasbihalWeb, :view
  alias HasbihalWeb.Api.AuthView

  def render("token.json", %{token: token}) do
    %{token: token}
  end
end
