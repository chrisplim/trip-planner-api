defmodule TripPlannerWeb.V1.OpenApi.OpenApiSpec do
  @moduledoc """
  Defines the OpenApi spec for our app
  """
  @behaviour OpenApiSpex.OpenApi

  alias OpenApiSpex.Components
  alias OpenApiSpex.Info
  alias OpenApiSpex.OpenApi
  alias OpenApiSpex.Paths
  alias OpenApiSpex.SecurityScheme
  alias OpenApiSpex.Server
  alias TripPlannerWeb.Endpoint
  alias TripPlannerWeb.Router

  def spec do
    # Discover request/response schemas from path specs
    OpenApiSpex.resolve_schema_modules(%OpenApi{
      servers: [
        # Populate the Server info from a phoenix endpoint
        Server.from_endpoint(Endpoint)
      ],
      info: %Info{
        title: to_string(Application.spec(:trip_planner, :description)),
        version: to_string(Application.spec(:trip_planner, :vsn)),
        description: "The API for the Trip Planner App"
      },
      # Populate the paths from a phoenix router
      paths: Paths.from_router(Router),
      components: %Components{
        securitySchemes: %{
          "authorization" => %SecurityScheme{
            type: "http",
            scheme: "bearer",
            bearerFormat: "JWT",
            description: "Token must be provided in the headers via `Authorization: Bearer <token>`"
          }
        }
      }
    })
  end
end
