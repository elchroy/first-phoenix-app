defmodule Hello.Accounts do
    @moduledoc """
    The Accounts context
    """

    import Ecto.Query, warn: false
    alias Hello.Repo

    alias Hello.Accounts.User

    @doc """
    Creates a new user

    ## Examples
        
        iex> create_user(%{field: value})
        {:ok, %User{}}
        
        iex> create_user(%{field: value})
        {:error, %Ecto.Changeset{}}

    """
    def create_user(attr\\%{}) do
        %User{}
        |> User.changeset(attr)
        |> Repo.insert()
    end

    @doc """
    List users
    
    ## Examples

      iex> list_users()
      [%User{}, ...]
      
    """
    def list_users() do
        Repo.all(User)
    end
end