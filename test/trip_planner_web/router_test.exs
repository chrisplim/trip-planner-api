defmodule TripPlannerWeb.RouterTest do
  use ExUnit.Case
  use TripPlannerWeb.ConnCase

  describe "openapi" do
    test "/openapi", %{conn: conn} do
      conn =
        conn
        |> get(Routes.swagger_ui_path(conn, path: "/api/openapi"))

      assert html_response(conn, 200)
    end

    test "/api/openapi", %{conn: conn} do
      conn =
        conn
        |> get(Routes.render_spec_path(conn, []))

      assert json_response(conn, 200)
    end
  end
end
