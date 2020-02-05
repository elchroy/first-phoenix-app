defmodule HelloWeb.UserController do
    use HelloWeb, :controller
    alias Hello.Accounts

    def index(conn, _params) do
        users = Accounts.list_users()
        render(conn, "index.json", users: users)
    end

    def show(conn, %{"id" => user_id}) do
        case Accounts.get_user(user_id) do
            nil -> conn |> put_status(:not_found) |> text("User not found")
            user -> render(conn, "show.json", user: user)
        end
    end

    def create(conn, %{"user" => user_params}) do
        case Accounts.create_user(user_params) do
            {:error, _} -> conn
                |> put_status(400)
                |> json(%{ :error => "invalid data", :data => user_params })
            {:ok, user} -> conn
                |> put_resp_content_type("application/json")
                |> put_status(:created)
                |> render("show.json", user: user)
        end
    end

    def update(conn, %{ "id" => user_id, "user" => user_params }) do
        user = Accounts.get_user!(user_id)

        case Accounts.update_user(user, user_params) do
            {:error, _} -> conn
                |> put_status(:bad_request)
                |> json(%{ :error => "invalid data", :data => user_params })
            { :ok, user } -> conn |> render("show.json", user: user)
        end
    end
end