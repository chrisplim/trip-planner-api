defmodule TripPlannerWeb.UserController do
  use TripPlannerWeb, :controller
  # use TripPlannerWeb.CurrentUser

  # alias TripPlanner.Auth.Auth
  alias TripPlanner.Schemas.User
  alias TripPlanner.Users
  # alias TripPlannerWeb.FallbackController

  # action_fallback(FallbackController)

  def register_user(conn, attrs) do
    IO.inspect("attrs: #{inspect(attrs)}")

    with {:ok, user} <- Users.create_user(attrs) do
      #      {:ok, tokens} <- Auth.create_tokens_for_user(user),
      #      {:ok, _} <- Users.update_refresh_token(user, tokens.refresh_token) do
      #   render(conn, "user_auth.json", %{user: user, tokens: tokens})
      render(conn, "user.json", %{user: user})
    end
  end

  # def get_user_me(conn, _, %User{} = current_user) do
  #   with {:ok, user} <- Users.get_user_profile(current_user.id) do
  #     render(conn, "user_profile.json", %{user: user})
  #   end
  # end
end
