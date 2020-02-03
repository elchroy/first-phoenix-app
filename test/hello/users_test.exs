defmodule Hello.UsersTest do
  use Hello.DataCase

  alias Hello.Users

  describe "users" do
    alias Hello.Users.User

    @valid_attrs %{bio: "some bio", email: "some@email", name: "some name", num_of_pets: 42}
    @update_attrs %{bio: "some updated bio", email: "some updated@email", name: "some updated name", num_of_pets: 43}
    @invalid_attrs %{bio: nil, email: nil, name: nil, num_of_pets: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Users.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Users.create_user(@valid_attrs)
      assert user.bio == "some bio"
      assert user.email == "some@email"
      assert user.name == "some name"
      assert user.num_of_pets == 42
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Users.update_user(user, @update_attrs)
      assert user.bio == "some updated bio"
      assert user.email == "some updated@email"
      assert user.name == "some updated name"
      assert user.num_of_pets == 43
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end

    test "num_of_pets is not required" do
      changeset = User.changeset(%User{}, Map.delete(@valid_attrs, :num_of_pets))
      assert changeset.valid?
    end
    
    test "bio must be at least two characters long" do
      attrs = %{@valid_attrs | bio: "I"}
      changeset = User.changeset(%User{}, attrs)
      assert %{bio: ["should be at least 2 character(s)"]} = errors_on(changeset)
      refute changeset.valid?
    end
    
    test "bio must be at most 140 characters long" do
      attrs = %{@valid_attrs | bio: String.duplicate("here", 47)}
      changeset = User.changeset(%User{}, attrs)
      assert %{bio: ["should be at most 140 character(s)"]} = errors_on(changeset)
      refute changeset.valid?
    end
    
    @tag :only
    test "email attr must have an @ symbol" do
      attrs = %{@valid_attrs | email: "invalid-at-email-dot-com"}
      changeset = User.changeset(%User{}, attrs)
      assert %{email: ["email must include at least an @"]} = errors_on(changeset)
      # refute changeset.valid?
    end
  end
end
