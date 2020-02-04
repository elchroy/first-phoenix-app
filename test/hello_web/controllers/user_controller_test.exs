defmodule HelloWeb.UserControllerTest do
    use HelloWeb.ConnCase

    alias Hello.Accounts

    @create_attrs %{name: "John", email: "john@example.com", password: "john pass"}

    describe "index/2" do
        setup [:create_user]
        
        test "index/2 responds with all Users", %{conn: conn, user: user} do
    
            expected = %{
                "data" => [
                    %{ "name" => user.name, "email" => user.email},
                ]
            }
    
            response = conn
            |> get(Routes.user_path(conn, :index))
            |> json_response(200)
    
            assert response == expected
        end
    end


    @tag :only
    describe "create/2" do
        test "Creates, and responds with a newly created user if attributes are valid", %{conn: conn} do
            response = conn
            |> post(Routes.user_path(conn, :create, user: @create_attrs))
            |> json_response(201)

            expected = %{
                "data" => %{"email" => "john@example.com", "name" => "John"}
            }

            assert response == expected
        end
        test "Returnds an error and does not create a use if attributes are invalid"
    end

    describe "show/2" do

        setup [:create_user]

        test "Responds with user info if the user is found", %{conn: conn, user: user} do

            response = conn
            |> get(Routes.user_path(conn, :show, user.id))
            |> json_response(200)

            expected = %{
                "data" => %{"name" => user.name, "email" => user.email}
            }

            assert response == expected
        end

        test "Responds wtih a message indicating that the user is not found", %{conn: conn} do
            response = conn
            |> get(Routes.user_path(conn, :show, "-1111"))
            |> text_response(404)
            |> IO.inspect(label: "\n this")

            assert response == "User not found"
        end
    end

    # describe "update/2" do
    #     test "Edits, and responds with the user if attributes are valid"
    #     test "Returnds an error and does not edit the user if attributes are invalid"
    # end

    # test "delete/2 and responds with :ok if the user was deleted"

    defp create_user(_) do
        {:ok, user} = Accounts.create_user(@create_attrs)
        {:ok, user: user}
    end
end