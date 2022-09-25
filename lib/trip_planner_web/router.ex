defmodule TripPlannerWeb.Router do
  use TripPlannerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: TripPlannerWeb.OpenApi.OpenApiSpec
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

    get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"
  end

  scope "/api" do
    pipe_through([:parsed_body, :api])

    scope "/sessions" do
      post("/login", TripPlannerWeb.SessionController, :login)
    end

    scope "/users" do
      post("/register", TripPlannerWeb.UserController, :register_user)
    end

    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
  end

  # Authed endpoints
  scope "/api", TripPlannerWeb do
    pipe_through([:parsed_body, :api, :api_auth_required])

    scope "/sessions" do
      post("/refresh_token", SessionController, :refresh_token)
    end

    scope "/users" do
      get("/me", UserController, :get_user_me)
    end

    resources "/trips", TripController, only: [:index, :create, :show, :update, :delete]
  end
end
