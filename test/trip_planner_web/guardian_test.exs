defmodule TripPlannerWeb.GuardianTest do
  use ExUnit.Case
  use TripPlannerWeb.ConnCase

  import TripPlanner.Factory
  alias TripPlannerWeb.Guardian

  describe "subject_for_token" do
    test "user as subject" do
      user = insert(:user)
      assert {:ok, _, _} = Guardian.encode_and_sign(user)
    end

    test "something else as subject" do
      assert {:error, "Not found"} = Guardian.encode_and_sign("something else")
    end
  end

  describe "resource_from_claims" do
    test "authenticated user", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> authenticate(user)
        |> get(Routes.user_path(conn, :get_user_me))

      assert json_response(conn, 200)
    end

    test "unauthenticated user", %{conn: conn} do
      user = insert(:user)
      {:ok, refresh_token, _claims} = Guardian.encode_and_sign(user)

      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer #{refresh_token}")
        |> get(Routes.user_path(conn, :get_user_me))

      assert response(conn, 401)
    end

    test "no sub claim", %{conn: _conn} do
      assert {:error, "No subject"} = Guardian.resource_from_claims(%{})
    end
  end
end
