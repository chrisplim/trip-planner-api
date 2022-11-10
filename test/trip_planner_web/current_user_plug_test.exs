defmodule TripPlannerWeb.CurrentUserPlugTest do
  use TripPlannerWeb.ConnCase, async: true
  import TripPlanner.Factory
  alias TripPlanner.Schemas.User
  alias TripPlannerWeb.Guardian

  describe "call" do
    test "conn is halted when no valid user" do
      conn =
        build_conn()
        |> get("/api/v1/users/me")

      assert conn.halted
    end

    test "conn has user assigned when valid user" do
      user = insert(:user, jwt_refresh_token: "some token")
      user_id = user.id
      {:ok, token, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "refresh", ttl: {2, :weeks})

      conn = build_conn() |> put_req_header("authorization", "Bearer #{token}") |> get("/api/v1/users/me")
      assert !conn.halted
      assert %{current_user: %User{id: ^user_id}} = conn.assigns
    end
  end
end
