defmodule TripPlannerWeb.V1.Sessions.SessionControllerTest do
  use ExUnit.Case
  use TripPlannerWeb.ConnCase

  import TripPlanner.Factory

  describe "login" do
    test "correct password", %{conn: conn} do
      password = "my_correct_password"
      password_hash = Argon2.hash_pwd_salt(password)
      user = insert(:user, username: "foobar", password_hash: password_hash)
      user_id = user.id

      params = %{username: "foobar", password: password}

      conn = post(conn, Routes.session_path(conn, :login, params))

      assert %{
               "user" => %{
                 "id" => ^user_id,
                 "first_name" => _,
                 "last_name" => _,
                 "email" => _,
                 "phone" => _,
                 "username" => _
               },
               "tokens" => %{"access_token" => _, "refresh_token" => _}
             } = json_response(conn, 200)
    end

    @tag capture_log: true
    test "unable to login", %{conn: conn} do
      password = "my_correct_password"
      password_hash = Argon2.hash_pwd_salt(password)
      insert(:user, username: "foobar", password_hash: password_hash)
      params = %{username: "foobar", password: "incorrect_password"}

      conn = post(conn, Routes.session_path(conn, :login, params))

      assert json_response(conn, 401) == %{"error" => %{"detail" => "Unauthorized"}}
    end
  end

  describe "refresh_token" do
    test "authenticated user", %{conn: conn} do
      user = insert(:user)

      conn = authenticate(conn, user)

      # Reload the user to get the jwt_refresh_token
      user = TripPlanner.Repo.reload!(user)
      refresh_token = user.jwt_refresh_token
      params = %{refresh_token: refresh_token}

      conn = post(conn, Routes.session_path(conn, :refresh_token, params))

      assert %{
               "tokens" => %{"access_token" => _, "refresh_token" => new_refresh_token}
             } = json_response(conn, 200)

      # The new_refresh_token should not be equal to the old refresh token
      refute refresh_token == new_refresh_token

      # The jwt_refresh_token should be updated
      user = TripPlanner.Repo.reload!(user)
      assert user.jwt_refresh_token == new_refresh_token
    end

    @tag capture_log: true
    test "authenticated user, but refresh_token passed in doesnt match", %{conn: conn} do
      user = insert(:user)

      conn = authenticate(conn, user)

      params = %{refresh_token: "non matching token"}
      conn = post(conn, Routes.session_path(conn, :refresh_token, params))

      assert json_response(conn, 401) == %{"error" => %{"detail" => "Unauthorized"}}
    end

    test "unauthenticated user", %{conn: conn} do
      insert(:user, jwt_refresh_token: "some_token")

      params = %{refresh_token: "some_token"}
      conn = post(conn, Routes.session_path(conn, :refresh_token, params))

      assert json_response(conn, 401) == %{"error" => %{"detail" => "unauthenticated"}}
    end
  end
end
