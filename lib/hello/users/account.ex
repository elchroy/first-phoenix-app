defmodule Hello.Accounts.User do
    use Ecto.Schema
    import Ecto.Changeset

    schema "users" do
        field :name, :string
        field :email, :string

        timestamps()
    end

    def changeset(user, attrs) do
        user
        |> cast(attrs, [:name, :email])
        |> validate_required([:name, :email])
        |> validate_length(:name, min: 2, max: 50)
        |> validate_format(:email, ~r/@/)
    end
end