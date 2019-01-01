defmodule HasbihalWeb.Api.AuthView do
  use HasbihalWeb, :view

  def render("token.json", %{token: token}) do
    %{token: token}
  end
end
