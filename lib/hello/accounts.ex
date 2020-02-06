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

    @doc """
    Get a single `%User{}` from the data store where the primary key matches the given id

    Returns `nil` if no result was found.
    
    ## Examples

      iex> get_user(234)
      {:ok, %User{}}

      iex> get_user(-1)
      nil
      
    """
    def get_user(user_id) do 
        Repo.get(User, user_id)
    end

    @doc """
    Show single user
    
    ## Examples

      iex> get_user!(user_id)
      {:ok, %User{}}

      iex> get_user!(user_id)
      {:error, %Ecto.Changeset{}}
      
    """
    def get_user!(user_id) do 
        Repo.get(User, user_id)
    end

    @doc """
    Updates an existing user

    ## Examples
        
        iex> update_user(%User{}, %{field: value})
        {:ok, %User{}}
        
        iex> update_user(%User{}, %{field: value})
        {:error, %Ecto.Changeset{}}

    """

    def update_user(user, update_attrs) do
      user
      |> User.changeset(update_attrs)
      |> Repo.update()
    end

    @doc """
    Deletes an existing user
    returns an error is user does not exist

    ## Examples
    
        iex> delete_user(%User{})
        {:ok, struct}
    
        iex> delete_user(%User{})
        {:error, Ecto.Changeset.t()}
        
    """
    def delete_user(user) do
      Repo.delete(user)
    end
end