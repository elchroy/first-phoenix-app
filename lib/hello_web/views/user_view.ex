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

  def render("error.json", %{changeset: changeset}) do
    %{ errors: errors_on(changeset) }
  end

  def render("okay.json", %{ message: message }) do
    %{ data: %{ message: message } }
  end
  
  # this should not be here
  # Already defined in test/support/data_case.ex
  defp errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
