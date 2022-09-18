defmodule TripPlannerWeb.TestAuthHelper do
  @moduledoc """
  Module with methods to help the authentication process on tests.
  """
  import Plug.Conn
  import TripPlanner.Factory

  alias TripPlanner.Auth.Auth
  alias TripPlanner.Users

  def authenticate(conn = %Plug.Conn{}, user \\ insert(:user)) do
    {:ok, %{access_token: access_token, refresh_token: refresh_token}} =
      Auth.create_tokens_for_user(user)

    {:ok, _} = Users.update_refresh_token(user, refresh_token)

    conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer #{access_token}")
  end
end
