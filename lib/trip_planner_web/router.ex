defmodule TripPlannerWeb.Router do
  use TripPlannerWeb, :router

  # alias TripPlannerWeb.Plugs.DateParamsParserPlug
  alias TripPlannerWeb.V1.Sessions.SessionController
  alias TripPlannerWeb.V1.Trips.ActivityController
  alias TripPlannerWeb.V1.Trips.TripController
  alias TripPlannerWeb.V1.Users.UserController

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: TripPlannerWeb.V1.OpenApi.OpenApiSpec
    # plug DateParamsParserPlug
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :parsed_body do
    plug(
      Plug.Parsers,
      parsers: [:urlencoded, {:json, json_decoder: Jason}]
    )
  end

  pipeline :api_auth_required do
    plug(TripPlannerWeb.AuthPipeline)
    plug(TripPlannerWeb.CurrentUserPlug)
  end

  scope "/" do
    pipe_through :browser

    get "/openapi", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"
  end

  scope "/api" do
    pipe_through([:api])
    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
  end

  scope "/api" do
    scope "/v1" do
      pipe_through([:parsed_body, :api])

      scope "/sessions" do
        post("/login", SessionController, :login)
      end

      scope "/users" do
        post("/register", UserController, :register_user)
      end
    end

    scope "/v1" do
      # Authed endpoints
      pipe_through([:parsed_body, :api, :api_auth_required])

      scope "/sessions" do
        post("/refresh_token", SessionController, :refresh_token)
      end

      scope "/users" do
        get("/me", UserController, :get_user_me)
      end

      resources "/trips", TripController, only: [:index, :create, :show, :update, :delete], param: "trip_id"

      scope "/trips/:trip_id", as: :trip do
        resources "/activities", ActivityController,
          only: [:create, :show, :update, :delete],
          param: "activity_id"
      end
    end
  end
end
