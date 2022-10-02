defmodule TripPlannerWeb.V1.Sessions.SessionView do
  use TripPlannerWeb, :view

  def render("refreshed_tokens.json", %{access_token: access_token, refresh_token: refresh_token}) do
    %{tokens: %{access_token: access_token, refresh_token: refresh_token}}
  end
end
