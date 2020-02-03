defmodule HelloWeb.UserController do
    use HelloWeb, :controller
    alias Hello.Accounts

    def index(conn, _params) do
        users = Accounts.list_users()
        render(conn, "index.json", users: users)
    end

    def show(conn, %{"id" => user_id}) do
        case Accounts.show_user(user_id) do
            nil -> conn |> put_status(:not_found) |> text("User not found")
            user -> render(conn, "show.json", user: user)
        end
    end
end