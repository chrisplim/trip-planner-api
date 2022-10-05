defmodule TripPlanner.Users.UsersTest do
  use TripPlanner.DataCase
  import TripPlanner.Factory

  alias TripPlanner.Users.Users
  alias TripPlanner.Schemas.User

  describe "create_user" do
    @valid_attrs %{
      first_name: "Billy",
      last_name: "Bob",
      username: "billybob",
      password: "fakepass",
      email: "fake@email.com"
    }

    test "valid attrs creates user" do
      assert {:ok, %User{first_name: "Billy", last_name: "Bob", username: "billybob", email: "fake@email.com"}} =
               Users.create_user(@valid_attrs)
    end

    test "invalid email format returns error changeset" do
      attrs = Map.put(@valid_attrs, :email, "invalid_email.com")

      assert {:error,
              %Ecto.Changeset{
                errors: [email: {"must have no whitespace and must contain the @ symbol", [validation: :format]}]
              }} = Users.create_user(attrs)
    end

    test "username too short returns error changeset" do
      attrs = Map.put(@valid_attrs, :username, "bob")

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  username:
                    {"should be at least %{count} character(s)",
                     [count: 4, validation: :length, kind: :min, type: :string]}
                ]
              }} = Users.create_user(attrs)
    end

    test "username too long returns error changeset" do
      long_username = String.duplicate("a", 51)
      attrs = Map.put(@valid_attrs, :username, long_username)

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  username:
                    {"should be at most %{count} character(s)",
                     [count: 50, validation: :length, kind: :max, type: :string]}
                ]
              }} = Users.create_user(attrs)
    end

    test "already existing username returns error changeset" do
      user = insert(:user, username: @valid_attrs[:username])

      attrs = Map.put(@valid_attrs, :username, user.username)

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  username: {"has already been taken", [constraint: :unique, constraint_name: "users_username_index"]}
                ]
              }} = Users.create_user(attrs)
    end

    test "password too short returns error changeset" do
      attrs = Map.put(@valid_attrs, :password, "bob")

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  password:
                    {"should be at least %{count} character(s)",
                     [count: 8, validation: :length, kind: :min, type: :string]}
                ]
              }} = Users.create_user(attrs)
    end

    test "password too long returns error changeset" do
      long_password = String.duplicate("a", 101)
      attrs = Map.put(@valid_attrs, :password, long_password)

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  password:
                    {"should be at most %{count} character(s)",
                     [count: 100, validation: :length, kind: :max, type: :string]}
                ]
              }} = Users.create_user(attrs)
    end
  end

  describe "get_user" do
    test "existing user_id should return a user" do
      user = insert(:user)
      user_id = user.id
      assert {:ok, %User{id: ^user_id}} = Users.get_user(user_id)
    end

    test "non-existent user_id should return not_found error" do
      user_id = Faker.UUID.v4()
      assert {:error, :not_found} = Users.get_user(user_id)
    end
  end

  describe "update_refresh_token" do
    test "jwt_refresh_token is updated" do
      user = insert(:user)
      user_id = user.id
      refresh_token = "test_refresh_token"

      {:ok, %User{id: ^user_id, jwt_refresh_token: ^refresh_token}} = Users.update_refresh_token(user, refresh_token)
    end

    test "missing jwt_refresh_token should return error changeset" do
      user = insert(:user)

      {:error, %Ecto.Changeset{errors: [jwt_refresh_token: {"can't be blank", [validation: :required]}]}} =
        Users.update_refresh_token(user, "")
    end

    test "existing jwt_refresh_token should return error changeset" do
      existing_token = "existing_token"
      insert(:user, jwt_refresh_token: existing_token)
      user = insert(:user)

      {:error,
       %Ecto.Changeset{
         errors: [
           jwt_refresh_token:
             {"has already been taken", [constraint: :unique, constraint_name: "users_jwt_refresh_token_index"]}
         ]
       }} = Users.update_refresh_token(user, existing_token)
    end
  end

  describe "get_user_profile" do
    test "user_id exists should return a profile" do
      user = insert(:user)
      user_id = user.id
      assert {:ok, %User{id: ^user_id}} = Users.get_user_profile(user_id)
    end

    test "user_id doesn't exist, should return not_found error" do
      user_id = Faker.UUID.v4()
      assert {:error, :not_found} = Users.get_user_profile(user_id)
    end
  end
end
