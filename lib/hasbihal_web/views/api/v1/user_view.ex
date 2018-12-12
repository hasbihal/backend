defmodule HasbihalWeb.Api.V1.UserView do
  use HasbihalWeb, :view
  alias HasbihalWeb.Api.V1.UserView

  def render("index.json", %{users: users}) do
    %{
      data: Enum.map(users, fn user -> render_one(user, UserView, "user.json") end)
    }
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      summary: user.summary,
      location: user.location,
      avatar: Hasbihal.Avatar.url({user.avatar, user}, :thumb, signed: true),
      gender: %{0 => "none", 1 => "male", 2 => "female", 3 => "both"}[user.gender],
      inserted_at: NaiveDateTime.to_string(user.inserted_at)
    }
  end
end
