defmodule TripPlannerWeb.AuthPipeline do
  @moduledoc """
  Pipeline for Authentication. Uses Guardian and Bearer tokens
  """
  use Guardian.Plug.Pipeline,
    otp_app: :trip_planner,
    error_handler: TripPlanner.Auth.AuthErrorHandler,
    module: TripPlannerWeb.Guardian

  plug(Guardian.Plug.VerifyHeader, schema: "Bearer")
  plug(Guardian.Plug.LoadResource, allow_blank: true)
  plug(Guardian.Plug.EnsureAuthenticated)
end
