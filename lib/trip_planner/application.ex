defmodule TripPlanner.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Don't set this in production releases because Mix is not available
    if Application.get_env(:trip_planner, :load_dot_env) do
      env = Dotenv.load([".env", ".env.local"])
      System.put_env(env.values)
      Mix.Task.run("loadconfig")
    end

    children = [
      # Start the Ecto repository
      TripPlanner.Repo,
      # Start the Telemetry supervisor
      TripPlannerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TripPlanner.PubSub},
      # Start the Endpoint (http/https)
      TripPlannerWeb.Endpoint
      # Start a worker by calling: TripPlanner.Worker.start_link(arg)
      # {TripPlanner.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TripPlanner.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TripPlannerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
