defmodule TripPlannerWeb.V1.Sessions.SessionController do
  use TripPlannerWeb, :controller
  use TripPlannerWeb.CurrentUser
  use TripPlannerWeb.V1.OpenApi.OpenApiOperation

  alias TripPlanner.Auth.Auth
  alias TripPlanner.Schemas.User
  alias TripPlanner.Users.Users
  alias TripPlannerWeb.FallbackController
  alias TripPlannerWeb.Guardian
  alias TripPlannerWeb.V1.Users.UserView

  action_fallback(FallbackController)

  @doc """
  OpenApi spec for the login action
  """
  def login_operation do
    %Operation{
      tags: ["sessions"],
      summary: "Login",
      description: "Login",
      operationId: "SessionController.login",
      requestBody:
        request_body(
          "The attributes needed to login",
          "application/json",
          OpenApiSchemas.LoginRequest,
          required: true
        ),
      responses: %{
        200 =>
          response(
            "User info and Auth tokens",
            "application/json",
            OpenApiSchemas.UserAuthResponse
          )
      }
    }
  end

  def login(conn, %{"username" => username, "password" => password}, _) do
    with {:ok, user} <- Auth.authenticate_user(username, password),
         {:ok, tokens} <- Auth.create_tokens_for_user(user),
         {:ok, _} <- Users.update_refresh_token(user, tokens.refresh_token) do
      conn
      |> put_view(UserView)
      |> render("user_auth.json", %{user: user, tokens: tokens})
    end
  end

  @doc """
  OpenApi spec for the refresh_token action
  """
  def refresh_token_operation do
    %Operation{
      tags: ["sessions"],
      summary: "Refresh tokens",
      description: "Refresh the current user's auth tokens",
      operationId: "SessionController.refresh_token",
      security: [%{"authorization" => []}],
      requestBody:
        request_body(
          "The attributes needed to refresh a token",
          "application/json",
          OpenApiSchemas.RefreshTokenRequest,
          required: true
        ),
      responses: %{
        200 =>
          response(
            "Auth tokens",
            "application/json",
            OpenApiSchemas.TokensResponse
          )
      }
    }
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

  @doc """
  OpenApi spec for the logout action
  """
  def logout_operation do
    %Operation{
      tags: ["sessions"],
      summary: "Logout",
      description: "Logout by deleting the user's token",
      operationId: "SessionController.logout",
      security: [%{"authorization" => []}],
      requestBody:
        request_body(
          "The attributes needed to logout",
          "application/json",
          OpenApiSchemas.LogoutRequest,
          required: true
        ),
      responses: %{
        204 =>
          response(
            "204",
            nil,
            OpenApiSchemas.OkResponse
          )
      }
    }
  end

  def logout(
        conn,
        %{"refresh_token" => refresh_token},
        %User{jwt_refresh_token: refresh_token} = user
      ) do
    with {:ok, _} <- Auth.delete_token_for_user(user) do
      send_resp(conn, 204, "")
    else
      _ -> {:error, :unauthorized}
    end
  end

  def logout(_, _, _) do
    {:error, :unauthorized}
  end
end
