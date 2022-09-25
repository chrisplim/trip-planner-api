defmodule TripPlannerWeb.UserController do
  use TripPlannerWeb, :controller
  use TripPlannerWeb.CurrentUser
  use TripPlannerWeb.OpenApi.OpenApiOperation

  alias TripPlanner.Auth.Auth
  alias TripPlanner.Schemas.User
  alias TripPlanner.Users
  alias TripPlannerWeb.FallbackController

  action_fallback(FallbackController)

  @doc """
  OpenApi spec for the register_user action
  """
  def register_user_operation() do
    %Operation{
      tags: ["users"],
      summary: "Register new user",
      description: "Register new user",
      operationId: "UserController.register_user",
      requestBody:
        request_body(
          "The attributes needed to register a new user",
          "application/json",
          OpenApiSchemas.RegisterUserRequest,
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

  def register_user(conn, attrs, _) do
    with {:ok, user} <- Users.create_user(attrs),
         {:ok, tokens} <- Auth.create_tokens_for_user(user),
         {:ok, _} <- Users.update_refresh_token(user, tokens.refresh_token) do
      render(conn, "user_auth.json", %{user: user, tokens: tokens})
    end
  end

  @doc """
  OpenApi spec for the get_user_me action
  """
  def get_user_me_operation() do
    %Operation{
      tags: ["users"],
      summary: "Get current user information",
      description: "Get current user information",
      operationId: "UserController.get_user_me",
      security: [%{"authorization" => []}],
      responses: %{
        200 =>
          response(
            "Current User Response",
            "application/json",
            OpenApiSchemas.CurrentUserResponse
          )
      }
    }
  end

  def get_user_me(conn, _, %User{} = current_user) do
    with {:ok, user} <- Users.get_user_profile(current_user.id) do
      render(conn, "user_profile.json", %{user: user})
    end
  end
end
