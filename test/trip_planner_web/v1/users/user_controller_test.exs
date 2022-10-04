defmodule TripPlannerWeb.V1.Users.UserControllerTest do
  use ExUnit.Case
  use TripPlannerWeb.ConnCase

  import TripPlanner.Factory

  describe "register_user" do
    test "success", %{conn: conn} do
      params = %{
        first_name: "test_first_name",
        last_name: "test_last_name",
        email: "test@email",
        phone: "1234567890",
        username: "username",
        password: "testpassword"
      }

      conn = post(conn, Routes.user_path(conn, :register_user, params))

      assert %{
               "user" => %{
                 "id" => _,
                 "first_name" => "test_first_name",
                 "last_name" => "test_last_name",
                 "email" => "test@email",
                 "phone" => "1234567890",
                 "username" => "username"
               },
               "tokens" => %{"access_token" => _, "refresh_token" => _}
             } = json_response(conn, 200)
    end

    @tag capture_log: true
    test "failure", %{conn: conn} do
      params = %{
        email: "test@email"
      }

      conn = post(conn, Routes.user_path(conn, :register_user, params))

      assert %{"error" => _} = json_response(conn, 422)
    end
  end

  describe "get_user_me" do
    test "authenticated user", %{conn: conn} do
      user = insert(:user)
      user_id = user.id

      conn =
        conn
        |> authenticate(user)
        |> get(Routes.user_path(conn, :get_user_me))

      assert %{
               "user" => %{
                 "id" => ^user_id,
                 "first_name" => _,
                 "last_name" => _,
                 "email" => _,
                 "phone" => _,
                 "username" => _
               }
             } = json_response(conn, 200)
    end

    # test "authenticated user with other objects", %{conn: conn} do
    #   user = insert(:user)
    #   user_id = user.id

    #   conn =
    #     conn
    #     |> authenticate(user)
    #     |> get(Routes.user_path(conn, :get_user_me))

    #   assert %{
    #            "user" => %{
    #              "dob" => _,
    #              "email" => _,
    #              "id" => ^user_id,
    #              "name" => _,
    #              "username" => _
    #            }
    #          } = json_response(conn, 200)
    # end

    test "unauthenticated user", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :get_user_me))
      assert %{"error" => %{"detail" => "unauthenticated"}} = json_response(conn, 401)
    end
  end
end
