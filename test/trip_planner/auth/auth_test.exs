defmodule TripPlanner.Auth.AuthTest do
  use TripPlanner.DataCase
  import TripPlanner.Factory
  alias TripPlanner.Auth.Auth
  alias TripPlanner.Schemas.User

  describe "authenticate_user" do
    test "user is found; correct password" do
      user = insert(:user, username: "testuser", password_hash: Argon2.hash_pwd_salt("pass"))
      assert {:ok, ^user} = Auth.authenticate_user("testuser", "pass")
    end

    test "user is found; incorrect password" do
      insert(:user, username: "testuser", password_hash: Argon2.hash_pwd_salt("pass"))
      assert {:error, :unauthorized} = Auth.authenticate_user("testuser", "wrongpass")
    end

    test "user is not found" do
      assert {:error, :unauthorized} = Auth.authenticate_user("testuser", "pass")
    end
  end

  describe "create_tokens_for_user" do
    test "access_token and refresh_token are returned" do
      user = insert(:user)
      assert {:ok, %{access_token: _, refresh_token: _}} = Auth.create_tokens_for_user(user)
    end
  end

  describe "delete_token_for_user" do
    test "jwt_refresh_token is updated to nil" do
      user = insert(:user, jwt_refresh_token: "test token")
      assert {:ok, %User{jwt_refresh_token: nil}} = Auth.delete_token_for_user(user)
    end
  end
end
