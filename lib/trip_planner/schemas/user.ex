defmodule TripPlanner.Schemas.User do
  use TripPlanner.Schema
  import Ecto.Changeset
  alias TripPlanner.Schemas.Trip

  schema "users" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:username, :string)
    field(:password, :string, virtual: true, redact: true)
    field(:password_hash, :string)
    field(:email, :string)
    field(:phone, :string)
    field(:jwt_refresh_token, :string)

    many_to_many(:trips, Trip,
      join_through: "users_trips"
      # on_replace: :delete
    )

    timestamps(type: :utc_datetime)
  end

  def create_changeset(user, params) do
    user
    |> cast(params, [:first_name, :last_name, :username, :password, :email, :phone])
    |> validate_required([:first_name, :last_name, :username, :password, :email])
    |> validate_email()
    |> validate_length(:username, min: 4, max: 50)
    |> unique_constraint(:username)
    |> validate_length(:password, min: 8, max: 100)
    |> put_password_hash()
  end

  def refresh_token_changeset(user, attrs) do
    user
    |> cast(attrs, [:jwt_refresh_token])
    |> validate_required([:jwt_refresh_token])
    |> unique_constraint(:jwt_refresh_token)
  end

  defp validate_email(changeset) do
    changeset
    # rudimentary email format check
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/,
      message: "must have no whitespace and must contain the @ symbol"
    )
    |> unique_constraint(:email)
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password_hash: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
