defmodule TripPlannerWeb.UserViewTest do
  use ExUnit.Case
  alias TripPlannerWeb.UserView

  import TripPlanner.Factory

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TripPlanner.Repo)
  end

  test "user.json" do
    user = insert(:user)

    assert UserView.render("user.json", %{user: user}) == %{
             id: user.id,
             first_name: user.first_name,
             last_name: user.last_name,
             username: user.username,
             email: user.email,
             phone: user.phone
           }
  end

  test "user_auth.json" do
    user = insert(:user)

    tokens = %{access_token: "access_token", refresh_token: "refresh_token"}

    assert %{
             user: %{id: _, first_name: _, last_name: _, email: _, phone: _, username: _},
             tokens: ^tokens
           } = UserView.render("user_auth.json", %{user: user, tokens: tokens})
  end

  test "user_profile.json" do
    user = insert(:user)

    assert %{
             user: %{id: _, first_name: _, last_name: _, email: _, phone: _, username: _}
           } = UserView.render("user_profile.json", %{user: user})
  end
end
