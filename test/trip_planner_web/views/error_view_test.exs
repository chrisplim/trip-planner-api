defmodule TripPlannerWeb.ErrorViewTest do
  use TripPlannerWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(TripPlannerWeb.ErrorView, "404.json", []) == %{error: %{detail: "Not Found"}}
  end

  test "renders 500.json" do
    assert render(TripPlannerWeb.ErrorView, "500.json", []) ==
             %{error: %{detail: "Internal Server Error"}}
  end

  test "renders error.json" do
    assert render(TripPlannerWeb.ErrorView, "error.json", %{message: "Custom message", code: 400}) ==
             %{error: %{code: 400, message: "Custom message"}}
  end
end
