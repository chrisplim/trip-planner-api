defmodule TripPlannerWeb.SessionController do
  use TripPlannerWeb, :controller
  use TripPlannerWeb.CurrentUser

  alias TripPlanner.Auth.Auth
  alias TripPlanner.Schemas.User
  alias TripPlanner.Users
  alias TripPlannerWeb.FallbackController
  alias TripPlannerWeb.Guardian
  alias TripPlannerWeb.UserView

  action_fallback(FallbackController)

  def login(conn, %{"username" => username, "password" => password}, _) do
    with {:ok, user} <- Auth.authenticate_user(username, password),
         {:ok, tokens} <- Auth.create_tokens_for_user(user),
         {:ok, _} <- Users.update_refresh_token(user, tokens.refresh_token) do
      conn
      |> put_view(UserView)
      |> render("user_auth.json", %{user: user, tokens: tokens})
    end
  end

  def refresh_token(
        conn,
        %{"refresh_token" => refresh_token},
        %User{jwt_refresh_token: refresh_token} = current_user
      ) do
    # Refresh a token before it expires
    with {:ok, _old_stuff, {new_refresh_token, _new_claims}} <- Guardian.refresh(refresh_token),
         {:ok, _old_stuff, {new_access_token, _new_claims}} <-
           Guardian.exchange(refresh_token, "refresh", "access"),
         {:ok, _} <- Users.update_refresh_token(current_user, new_refresh_token) do
      render(conn, "refreshed_tokens.json", %{
        access_token: new_access_token,
        refresh_token: new_refresh_token
      })
    else
      _ -> {:error, :unauthorized}
    end
  end

  def refresh_token(_, _, _) do
    {:error, :unauthorized}
  end
end
