defmodule HasbihalWeb.Api.UserView do
  use HasbihalWeb, :view

  def render("index.json", %{users: users}) do
    %{
      data:
        Enum.map(users, fn user -> render_one(user, HasbihalWeb.Api.UserView, "user.json") end)
    }
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, HasbihalWeb.Api.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      summary: user.summary,
      location: user.location,
      avatar: user.avatar,
      gender: %{0 => "none", 1 => "male", 2 => "female", 3 => "both"}[user.gender]
    }
  end
end
