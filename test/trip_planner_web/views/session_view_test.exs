defmodule TripPlannerWeb.SessionViewTest do
  use ExUnit.Case
  alias TripPlannerWeb.SessionView

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TripPlanner.Repo)
  end

  test "refreshed_tokens.json" do
    tokens = %{access_token: "access_token", refresh_token: "refresh_token"}
    assert %{tokens: ^tokens} = SessionView.render("refreshed_tokens.json", tokens)
  end
end
