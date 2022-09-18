defmodule TripPlannerWeb.Router do
  use TripPlannerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
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

  scope "/api", TripPlannerWeb do
    pipe_through([:parsed_body, :api])

    scope "/sessions" do
      post("/login", SessionController, :login)
    end

    scope "/users" do
      post("/register", UserController, :register_user)
    end
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

    # post("/government_ids", GovernmentIdController, :create_government_id)
    # put("/government_ids", GovernmentIdController, :update_government_id)
    # delete("/government_ids", GovernmentIdController, :delete_government_id)
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  # if Mix.env() == :dev do
  #   scope "/dev" do
  #     pipe_through [:fetch_session, :protect_from_forgery]

  #     forward "/mailbox", Plug.Swoosh.MailboxPreview
  #   end
  # end
end
