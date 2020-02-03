defmodule HelloWeb.UserControllerTest do
    use HelloWeb.ConnCase

    alias Hello.Accounts

    test "index/2 responds with all Users", %{conn: conn} do
        users = [
            %{name: "John", email: "john@example.com", password: "john pass"},
            %{name: "Jane", email: "jane@example.com", password: "jane pass"},
        ]

        # create users local to this database connection and test
        [{:ok, user1}, {:ok, user2}] = Enum.map(users, &Accounts.create_user(&1))

        expected = %{
            "data" => [
                %{ "name" => user1.name, "email" => user1.email},
                %{ "name" => user2.name, "email" => user2.email}
            ]
        }

        response = conn
        |> get(Routes.user_path(conn, :index))
        |> json_response(200)

        assert response == expected
    end

    @tag :only
    describe "create/2" do
        test "Creates, and responds with a newly created user if attributes are valid"
        test "Returnds an error and does not create a use if attributes are invalid"
    end

    describe "show/2" do
        test "Responds with user info if the user is found"
        test "Responds wtih a message indicating that the user is not found"
    end

    describe "update/2" do
        test "Edits, and responds with the user if attributes are valid"
        test "Returnds an error and does not edit the user if attributes are invalid"
    end

    test "delete/2 and responds with :ok if the user was deleted"
end