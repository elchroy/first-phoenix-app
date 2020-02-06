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
        
        test "Returns an error and does not create a user if attributes are invalid", %{conn: conn} do
            attrs = %{name: "", email: ""}
            response = conn
            |> post(Routes.user_path(conn, :create, user: attrs))
            |> json_response(400)

            expected = %{
                "data" => %{"email" => "", "name" => ""},
                "error" => "invalid data"
            }

            assert response == expected
        end
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

            assert response == "User not found"
        end
    end

    describe "update/2" do

        setup [:create_user]
        
        test "Edits, and responds with the user if attributes are valid", %{conn: conn, user: user} do
            user_update = %{:name => "updated name", :email => "updated@email.com"}
            
            response = conn
            |> put(Routes.user_path(conn, :update, user), user: user_update)
            |> json_response(200)            
            
            expected = %{
                "data" => %{ "name" => "updated name", "email" => "updated@email.com" }
            }
            
            assert response == expected
        end
        
        test "Returns an error and does not edit the user if attributes are invalid", %{conn: conn, user: user} do
            invalid_update = %{:name => "", :email => "invalid-at-email-dot-com"}
            
            response = conn
            |> put(Routes.user_path(conn, :update, user), user: invalid_update)
            |> json_response(400)            
            
            expected = %{
                "errors" => %{
                    "email" => ["has invalid format"],
                    "name" => ["can't be blank"]
                }
            }
            
            assert response == expected
        end

        # test "Returns an error and does not edit the user if the user is not available"
    end

    describe "delete/2" do
        setup [:create_user]

        @tag :only
        test "responds with :ok if the user was deleted", %{conn: conn, user: user} do

            response = conn
            |> delete(Routes.user_path(conn, :delete, user.id))
            |> json_response(200)

            expected = %{
                "data" => %{
                    "message" => "User successfully deleted"
                }
            }

            assert response == expected
        end
        
        test "responds with :error message if the user to be deleted does not exist", %{conn: conn} do
            response = conn
            |> delete(Routes.user_path(conn, :delete, -11111))
            |> json_response(404)
            
            expected = %{
                "data" => %{
                    "message" => "Delete unsuccessful. User not found"
                }
            }
            
            assert response == expected
        end
    end

    defp create_user(_) do
        {:ok, user} = Accounts.create_user(@create_attrs)
        {:ok, user: user}
    end
end