defmodule HelloWeb.UserView do
  use HelloWeb, :view

  def render("index.json", %{users: users}) do
    %{ data: render_many(users, HelloWeb.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{ data: render_one(user, HelloWeb.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{ name: user.name, email: user.email }
  end
end
